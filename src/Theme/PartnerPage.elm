module Theme.PartnerPage exposing (viewInfo)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, auto, batch, calc, center, color, display, displayFlex, fontStyle, important, inlineBlock, margin2, margin4, marginBlockEnd, marginBlockStart, marginTop, maxWidth, minus, normal, paddingTop, pct, px, rem, textAlign, width)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Html.Styled exposing (Html, a, address, div, h3, hr, img, p, section, span, text)
import Html.Styled.Attributes exposing (alt, css, href, id, src, target)
import Theme.Global exposing (hrStyle, introTextLargeStyle, linkStyle, normalFirstParagraphStyle, pink, smallInlineTitleStyle, viewBackButton, white, withMediaMediumDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.TransMarkdown


viewInfo localModel { partner, events } =
    section [ css [ margin2 (rem 0) (rem 0.35) ] ]
        [ text ""

        --[ partnerLogo partner.maybeLogo partner.name
        , div [ css [ descriptionStyle ] ] (Theme.TransMarkdown.markdownToHtml (t (PartnerDescriptionText partner.description partner.name)))
        , hr [ css [ hrStyle ] ] []
        , section [ css [ contactWrapperStyle ] ]
            [ div [ css [ contactSectionStyle ] ]
                [ h3 [ css [ contactHeadingStyle, Theme.Global.smallInlineTitleStyle ] ] [ text (t PartnerContactsHeading) ]
                , viewContactDetails partner.maybeUrl partner.maybeContactDetails
                ]
            , div [ css [ contactSectionStyle ] ]
                [ h3 [ css [ contactHeadingStyle, Theme.Global.smallInlineTitleStyle ] ] [ text (t PartnerAddressHeading) ]
                , viewAddress partner.maybeAddress
                ]
            ]
        , hr [ css [ hrStyle ] ] []
        , viewPartnerEvents localModel { partner = partner, events = events }
        , case partner.maybeGeo of
            Just geo ->
                div [ css [ mapContainerStyle ] ]
                    [ p []
                        [ Theme.Global.mapImage
                            (t (MapImageAltText partner.name))
                            { latitude = geo.latitude, longitude = geo.longitude }
                        ]
                    ]

            Nothing ->
                div [ css [ mapContainerStyle ] ] [ text "" ]
        ]


viewPartnerEvents localModel { partner, events } =
    let
        eventAreaTitle =
            h3 [ css [ smallInlineTitleStyle, color white ] ] [ text (t (PartnerUpcomingEventsText partner.name)) ]
    in
    section [ id "events" ]
        (if List.length events > 0 then
            if List.length events > 20 then
                [ eventAreaTitle

                -- TODO , Page.Events.viewEvents localModel
                ]

            else
                let
                    futureEvents =
                        Data.PlaceCal.Events.afterDate events localModel.nowTime

                    pastEvents =
                        Data.PlaceCal.Events.onOrBeforeDate events localModel.nowTime
                in
                [ if List.length futureEvents > 0 then
                    div []
                        [ eventAreaTitle

                        --TODO , Page.Events.viewEventsList futureEvents
                        ]

                  else
                    div [] []
                , if List.length pastEvents > 0 then
                    div []
                        [ h3 [ css [ smallInlineTitleStyle, color white ] ] [ text (t (PartnerPreviousEventsText partner.name)) ]

                        -- TODO, Page.Events.viewEventsList pastEvents
                        ]

                  else
                    div [] []
                ]

         else
            [ eventAreaTitle
            , p [ css [ introTextLargeStyle, color pink, important (maxWidth (px 636)) ] ] [ text (t (PartnerEventsEmptyText partner.name)) ]
            ]
        )


viewContactDetails : Maybe String -> Maybe Data.PlaceCal.Partners.Contact -> Html msg
viewContactDetails maybeUrl maybeContactDetails =
    if maybeUrl == Nothing && maybeContactDetails == Nothing then
        p [ css [ contactItemStyle ] ] [ text (t PartnerContactsEmptyText) ]

    else
        address []
            [ case maybeContactDetails of
                Just contactDetails ->
                    span []
                        [ if String.length contactDetails.telephone > 0 then
                            p [ css [ contactItemStyle ] ] [ text contactDetails.telephone ]

                          else
                            text ""
                        , if String.length contactDetails.email > 0 then
                            p
                                [ css [ contactItemStyle ] ]
                                [ a
                                    [ href ("mailto:" ++ contactDetails.email)
                                    , css [ linkStyle ]
                                    ]
                                    [ text contactDetails.email
                                    ]
                                ]

                          else
                            text ""
                        ]

                Nothing ->
                    text ""
            , case maybeUrl of
                Just url ->
                    p [ css [ contactItemStyle ] ] [ a [ href url, target "_blank", css [ linkStyle ] ] [ text (Copy.Text.urlToDisplay url) ] ]

                Nothing ->
                    text ""
            ]


viewAddress : Maybe Data.PlaceCal.Partners.Address -> Html msg
viewAddress maybeAddress =
    case maybeAddress of
        Just addressFields ->
            address []
                [ div [] (String.split ", " addressFields.streetAddress |> List.map (\line -> p [ css [ contactItemStyle ] ] [ text line ]))
                , p [ css [ contactItemStyle ] ]
                    [ text addressFields.postalCode
                    ]
                , p [ css [ contactItemStyle ] ]
                    [ a [ href (t (GoogleMapSearchUrl addressFields.streetAddress)), css [ linkStyle ], target "_blank" ] [ text (t SeeOnGoogleMapText) ] ]
                ]

        Nothing ->
            p [ css [ contactItemStyle ] ] [ text (t PartnerAddressEmptyText) ]


partnerLogo : Maybe String -> String -> Html msg
partnerLogo maybeLogoUrl partnerName =
    case maybeLogoUrl of
        Just logoUrl ->
            if Copy.Text.isValidUrl logoUrl then
                div [ css [ partnerLogoContainer ] ]
                    [ img [ src logoUrl, css [ partnerLogoStyle ], alt (partnerName ++ " logo") ] []
                    , hr [ css [ hrStyle ] ] []
                    ]

            else
                text ""

        Nothing ->
            text ""



---------
-- Styles
---------


descriptionStyle : Style
descriptionStyle =
    batch
        [ normalFirstParagraphStyle
        , withMediaTabletLandscapeUp
            [ margin2 (rem 2) auto
            , maxWidth (px 636)
            ]
        , withMediaTabletPortraitUp
            [ margin2 (rem 2) (rem 2) ]
        ]


contactWrapperStyle : Style
contactWrapperStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex ]
        ]


contactSectionStyle : Style
contactSectionStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 50), marginTop (rem -2) ]
        ]


contactHeadingStyle : Style
contactHeadingStyle =
    batch [ color Theme.Global.pink ]


contactItemStyle : Style
contactItemStyle =
    batch
        [ textAlign center
        , fontStyle normal
        , marginBlockStart (rem 0)
        , marginBlockEnd (rem 0)
        ]


mapContainerStyle : Style
mapContainerStyle =
    batch
        [ margin4 (rem 3) (calc (rem -1.1) minus (px 1)) (calc (rem -0.75) minus (px 1)) (calc (rem -1.1) minus (px 1))
        , withMediaMediumDesktopUp
            [ margin4 (rem 3) (calc (rem -1.85) minus (px 1)) (calc (rem -1.85) minus (px 1)) (calc (rem -1.85) minus (px 1)) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 3) (calc (rem -2.35) minus (px 1)) (px -1) (calc (rem -2.35) minus (px 1)) ]
        ]


partnerLogoContainer : Style
partnerLogoContainer =
    batch
        [ textAlign center
        , paddingTop (rem 2)
        ]


partnerLogoStyle : Style
partnerLogoStyle =
    batch
        [ display inlineBlock
        ]
