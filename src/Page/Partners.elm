module Page.Partners exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, backgroundColor, batch, bold, borderBottomColor, borderBottomStyle, borderBottomWidth, borderRadius, calc, center, color, display, displayFlex, flexEnd, flexWrap, fontSize, fontStyle, fontWeight, hover, inlineBlock, int, italic, justifyContent, letterSpacing, margin2, marginBottom, marginLeft, marginRight, minus, none, padding, padding2, pct, px, rem, solid, spaceBetween, textAlign, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h3, h4, li, p, section, span, styled, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Theme.Global as Theme exposing (darkPurple, pink, purple, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    List Data.PlaceCal.Partners.Partner


data : DataSource (List Data.PlaceCal.Partners.Partner)
data =
    DataSource.map (\sharedData -> sharedData.allPartners) Data.PlaceCal.Partners.partnersData


head :
    StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = PartnersTitle
        , description = PartnersMetaDescription
        , imageSrc = Nothing
        }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t (PageMetaTitle (t PartnersTitle))
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t PartnersTitle
            , bigText = { text = t PartnersIntroSummary, node = "p" }
            , smallText = Just [ t PartnersIntroDescription ]
            , innerContent = Just (viewPartners static)
            , outerContent = Nothing
            }
        ]
    }


viewPartners : StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams -> Html msg
viewPartners static =
    section []
        [ h3 [ css [ partnersListTitleStyle ] ] [ text "All partners" ]
        , if List.length static.data > 0 then
            ul [ css [ listStyle ] ] (List.map (\partner -> viewPartner partner) static.data)

          else
            p [] [ text (t PartnersListEmpty) ]
        , viewMap static.data
        ]


viewPartner : Data.PlaceCal.Partners.Partner -> Html msg
viewPartner partner =
    li [ css [ listItemStyle ] ]
        [ a
            [ href (TransRoutes.toAbsoluteUrl (Partner partner.id))
            , css [ partnerLink ]
            ]
            [ div [ css [ partnerTopRowStyle ] ]
                [ h4 [ css [ partnerNameStyle ] ] [ text partner.name ]
                , viewAreaTag partner.areasServed partner.maybeAddress
                ]
            , div [ css [ partnerBottomRowStyle ] ]
                [ p [ css [ partnerDescriptionStyle ] ]
                    [ text partner.summary
                    ]
                ]
            ]
        ]


viewMap : List Data.PlaceCal.Partners.Partner -> Html msg
viewMap partnerList =
    div [ css [ featurePlaceholderStyle ] ]
        [ Theme.mapImageMulti
            (t PartnersMapAltText)
            (List.filter (\partner -> partner.maybeGeo /= Nothing) partnerList
                |> List.map
                    (\partner ->
                        case partner.maybeGeo of
                            Just geo ->
                                { latitude = geo.latitude
                                , longitude = geo.longitude
                                }

                            Nothing ->
                                { latitude = "0"
                                , longitude = "0"
                                }
                    )
            )
        ]


viewAreaTag :
    List Data.PlaceCal.Partners.ServiceArea
    -> Maybe Data.PlaceCal.Partners.Address
    -> Html msg
viewAreaTag serviceAreas maybeAddress =
    if List.length serviceAreas > 0 then
        ul [ css [ areaTagStyle ] ]
            (List.map
                (\area ->
                    li []
                        [ partnerAreaTagSpan [] [ text (areaNameString area) ]
                        ]
                )
                serviceAreas
            )

    else
        viewMaybePostalCode maybeAddress


areaNameString : Data.PlaceCal.Partners.ServiceArea -> String
areaNameString serviceArea =
    case serviceArea.abbreviatedName of
        Just shortName ->
            shortName

        Nothing ->
            serviceArea.name


viewMaybePostalCode : Maybe Data.PlaceCal.Partners.Address -> Html msg
viewMaybePostalCode maybeAddress =
    case maybeAddress of
        Just address ->
            partnerAreaTagSpan []
                [ text (areaDistrictString address)
                ]

        Nothing ->
            text ""


areaDistrictString : Data.PlaceCal.Partners.Address -> String
areaDistrictString address =
    String.split " " address.postalCode
        |> List.head
        |> Maybe.withDefault ""



--------------
-- With Styles
--------------


partnerAreaTagSpan : List (Html.Styled.Attribute msg) -> List (Html msg) -> Html msg
partnerAreaTagSpan =
    styled span
        [ backgroundColor darkPurple
        , color pink
        , display inlineBlock
        , marginLeft (rem 0.5)
        , padding2 (rem 0.25) (rem 0.5)
        , borderRadius (rem 0.3)
        , fontWeight (int 600)
        , fontSize (rem 0.877777)
        ]



---------
-- Styles
---------


partnersListTitleStyle : Style
partnersListTitleStyle =
    batch
        [ color white
        , textTransform uppercase
        , fontSize (rem 1.2)
        , letterSpacing (px 1.9)
        , textAlign center
        , margin2 (rem 2) (rem 1)
        , withMediaTabletLandscapeUp [ marginBottom (rem 0) ]
        ]


listStyle : Style
listStyle =
    batch
        [ padding2 (rem 0) (rem 0.5)
        , withMediaSmallDesktopUp [ padding (rem 0) ]
        , withMediaTabletLandscapeUp [ displayFlex, flexWrap wrap, padding2 (rem 0) (rem 2) ]
        ]


listItemStyle : Style
listItemStyle =
    batch
        [ hover
            [ descendants
                [ typeSelector "a" [ color pink ]
                , typeSelector "h4" [ color pink ]
                , typeSelector "div" [ borderBottomColor white ]
                ]
            ]
        , withMediaTabletLandscapeUp [ width (calc (pct 50) minus (rem 2)) ]
        , withMediaTabletPortraitUp [ margin2 (rem 1.5) (rem 1) ]
        ]


partnerTopRowStyle : Style
partnerTopRowStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , alignItems flexEnd
        , padding2 (rem 0.5) (rem 0)
        , borderBottomColor pink
        , borderBottomWidth (px 2)
        , borderBottomStyle solid
        , withMediaTabletLandscapeUp [ padding2 (rem 0.75) (rem 0) ]
        , transition [ Theme.borderTransition ]
        ]


partnerBottomRowStyle : Style
partnerBottomRowStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , padding2 (rem 0.5) (rem 0)
        , withMediaTabletLandscapeUp [ padding2 (rem 0.75) (rem 0) ]
        ]


partnerLink : Style
partnerLink =
    batch
        [ textDecoration none
        , color white
        , transition [ Theme.colorTransition ]
        ]


partnerNameStyle : Style
partnerNameStyle =
    batch
        [ fontSize (rem 1.2)
        , fontStyle italic
        , color white
        , transition [ Theme.colorTransition ]
        , withMediaTabletPortraitUp [ fontSize (rem 1.5) ]
        ]


partnerDescriptionStyle : Style
partnerDescriptionStyle =
    batch
        [ fontSize (rem 0.8777)
        , marginRight (rem 1)
        , withMediaTabletPortraitUp [ fontSize (rem 1.2) ]
        ]


areaTagStyle : Style
areaTagStyle =
    batch
        [ displayFlex
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , marginBottom (rem 2)
        , backgroundColor purple
        ]
