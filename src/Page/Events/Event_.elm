module Page.Events.Event_ exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (isValidUrl, t)
import Css exposing (Style, auto, batch, calc, center, color, displayFlex, em, fontSize, fontStyle, fontWeight, int, justifyContent, letterSpacing, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginTop, maxWidth, minus, normal, pct, px, rem, textAlign, textTransform, uppercase, width)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h4, hr, p, section, text, time)
import Html.Styled.Attributes exposing (css, href, target)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Theme.Global exposing (linkStyle, pink, smallInlineTitleStyle, withMediaMediumDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { event : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.map
        (\sharedData ->
            sharedData.allEvents
                |> List.map (\event -> { event = event.id })
        )
        Data.PlaceCal.Events.eventsData


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map2
        (\sharedData partnerData ->
            Maybe.withDefault
                Data.PlaceCal.Events.emptyEvent
                (List.filter (\event -> event.id == routeParams.event) sharedData.allEvents
                    |> List.map (\event -> { event | partner = Data.PlaceCal.Partners.eventPartnerFromId partnerData.allPartners event.partner.id })
                    |> List.head
                )
        )
        Data.PlaceCal.Events.eventsData
        Data.PlaceCal.Partners.partnersData


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = EventTitle static.data.name
        , description = EventMetaDescription static.data.name static.data.summary
        , imageSrc = Nothing
        }


type alias Data =
    Data.PlaceCal.Events.Event


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data.PlaceCal.Events.Event RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t (PageMetaTitle static.data.name)
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = static.data.name, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (viewEventInfo static.data)
            , outerContent = Just (viewButtons static.data)
            }
        ]
    }


viewEventInfo : Data.PlaceCal.Events.Event -> Html msg
viewEventInfo event =
    div []
        [ viewDateTimeSection event
        , hr [ css [ Theme.Global.hrStyle ] ] []
        , viewInfoSection event
        , hr [ css [ Theme.Global.hrStyle, marginTop (rem 2.5) ] ] []
        , viewAddressSection event
        , case event.maybeGeo of
            Just geo ->
                div [ css [ mapContainerStyle ] ]
                    [ p [] [ Theme.Global.mapImage { latitude = geo.latitude, longitude = geo.longitude } ]
                    ]

            Nothing ->
                div [ css [ mapContainerStyle ] ] [ text "" ]
        , publisherUrlSection event
        ]


viewDateTimeSection : Data.PlaceCal.Events.Event -> Html msg
viewDateTimeSection event =
    section [ css [ dateAndTimeStyle ] ]
        [ p [ css [ dateStyle ] ] [ time [] [ text (TransDate.humanDateFromPosix event.startDatetime) ] ]
        , p [ css [ timeStyle ] ] [ time [] [ text (TransDate.humanTimeFromPosix event.startDatetime), text " - ", text (TransDate.humanTimeFromPosix event.endDatetime) ] ]
        ]


viewInfoSection : Data.PlaceCal.Events.Event -> Html msg
viewInfoSection event =
    section [ css [ infoSectionStyle ] ]
        [ div []
            [ case event.partner.name of
                Just name ->
                    p [ css [ eventPartnerStyle ] ] [ a [ css [ linkStyle ], href (TransRoutes.toAbsoluteUrl (Partner event.partner.id)) ] [ text ("By " ++ name) ] ]

                Nothing ->
                    text ""
            ]
        , div [ css [ eventDescriptionStyle ] ]
            --  (Theme.TransMarkdown.markdownToHtml event.description)
            [ p [] [ text event.description ] ]
        ]


viewAddressSection : Data.PlaceCal.Events.Event -> Html msg
viewAddressSection event =
    section [ css [ addressSectionStyle ] ]
        [ div [ css [ addressItemStyle ] ]
            [ h4 [ css [ addressItemTitleStyle ] ] [ text "Contact Information " ]
            , case event.partner.maybeContactDetails of
                Just contact ->
                    div []
                        [ if contact.telephone /= "" then
                            p [ css [ contactItemStyle ] ] [ text contact.telephone ]

                          else
                            text ""
                        , if contact.email /= "" then
                            p [ css [ contactItemStyle ] ] [ a [ href ("mailto:" ++ contact.email), css [ Theme.Global.linkStyle ] ] [ text contact.email ] ]

                          else
                            text ""
                        ]

                Nothing ->
                    text ""
            , case event.partner.maybeUrl of
                Just url ->
                    if isValidUrl url then
                        p [ css [ contactItemStyle ] ]
                            [ a [ href url, target "_blank", css [ Theme.Global.linkStyle ] ]
                                [ text (Copy.Text.urlToDisplay url) ]
                            ]

                    else
                        text ""

                Nothing ->
                    text ""
            ]
        , div [ css [ addressItemStyle ] ]
            [ h4 [ css [ addressItemTitleStyle ] ] [ text "Event Address" ]
            , case event.location of
                Just aLocation ->
                    if aLocation.streetAddress == "" then
                        text ""

                    else
                        div [] (String.split ", " aLocation.streetAddress |> List.map (\line -> p [ css [ contactItemStyle ] ] [ text line ]))

                Nothing ->
                    text ""
            , case event.location of
                Just aLocation ->
                    if aLocation.postalCode == "" then
                        text ""

                    else
                        p [ css [ contactItemStyle ] ] [ text aLocation.postalCode ]

                Nothing ->
                    text ""
            ]
        ]


viewButtons : Data.PlaceCal.Events.Event -> Html msg
viewButtons event =
    section [ css [ buttonsStyle ] ]
        [ Theme.Global.viewBackButton
            (TransRoutes.toAbsoluteUrl (Partner event.partner.id) ++ "#events")
            (t (BackToPartnerEventsLinkText event.partner.name))
        , Theme.Global.viewBackButton
            (TransRoutes.toAbsoluteUrl Events)
            (t BackToEventsLinkText)
        ]


publisherUrlSection : Data.PlaceCal.Events.Event -> Html msg
publisherUrlSection event =
    case event.maybePublisherUrl of
        Just publisherUrl ->
            if isValidUrl publisherUrl then
                div [ css [ publisherSectionStyle ] ]
                    [ hr [ css [ Theme.Global.hrStyle, marginTop (rem 2.5) ] ] []
                    , a [ href publisherUrl, css [ Theme.Global.linkStyle ] ] [ text (t (EventVisitPublisherUrlText event.partner.name)) ]
                    ]

            else
                text ""

        Nothing ->
            text ""


dateAndTimeStyle : Style
dateAndTimeStyle =
    batch
        [ withMediaTabletPortraitUp
            [ margin2 (rem 2) (rem 0) ]
        , margin4 (rem 2) (rem 0) (rem 1) (rem 0)
        ]


dateStyle : Style
dateStyle =
    batch
        [ fontSize (rem 1.8)
        , textAlign center
        , marginBlockEnd (rem 0)
        , textTransform uppercase
        , fontWeight (int 900)
        , marginBottom (rem -0.5)
        ]


timeStyle : Style
timeStyle =
    batch
        [ fontSize (rem 1.2)
        , fontWeight (int 600)
        , textAlign center
        , textTransform uppercase
        , letterSpacing (px 1.9)
        , color pink
        , marginBlockStart (em 0)
        ]


infoSectionStyle : Style
infoSectionStyle =
    batch
        [ withMediaTabletLandscapeUp [ maxWidth (px 636), margin2 (rem 0) auto ]
        , withMediaTabletPortraitUp [ margin2 (rem 0) (rem 2) ]
        ]


eventPartnerStyle : Style
eventPartnerStyle =
    batch
        [ fontSize (rem 1.2)
        , textAlign center
        ]


eventDescriptionStyle : Style
eventDescriptionStyle =
    batch
        [ marginTop (rem 1)
        , marginBottom (rem 2)
        , withMediaTabletLandscapeUp [ marginTop (rem 3) ]
        , withMediaTabletPortraitUp [ marginTop (rem 2) ]
        ]


addressSectionStyle : Style
addressSectionStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex ]
        ]


addressItemStyle : Style
addressItemStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 50) ]
        ]


addressItemTitleStyle : Style
addressItemTitleStyle =
    batch
        [ color Theme.Global.pink
        , smallInlineTitleStyle
        , withMediaTabletPortraitUp [ marginTop (rem 1) ]
        ]


contactItemStyle : Style
contactItemStyle =
    batch
        [ textAlign center
        , fontStyle normal
        , marginBlockStart (em 0)
        , marginBlockEnd (em 0)
        ]


buttonsStyle : Style
buttonsStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex, justifyContent center ]
        ]


mapContainerStyle : Style
mapContainerStyle =
    batch
        [ margin4 (rem 3) (calc (rem -1.1) minus (px 1)) (calc (rem -0.75) minus (px 1)) (calc (rem -1.1) minus (px 1))
        , withMediaMediumDesktopUp
            [ margin4 (rem 3) (calc (rem -1.5) minus (px 1)) (calc (rem -1.5) minus (px 1)) (calc (rem -1.5) minus (px 1)) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 3) (calc (rem -2) minus (px 1)) (px -1) (calc (rem -2) minus (px 1)) ]
        ]


publisherSectionStyle : Style
publisherSectionStyle =
    batch
        [ textAlign center
        , marginBottom (rem 2)
        ]
