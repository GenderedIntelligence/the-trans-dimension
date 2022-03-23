module Page.Partners exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, alignItems, backgroundColor, batch, block, bold, borderBottomColor, borderBottomStyle, borderBottomWidth, borderRadius, calc, center, color, display, displayFlex, flexEnd, flexWrap, fontSize, fontStyle, fontWeight, hover, inline, inlineBlock, int, italic, justifyContent, letterSpacing, lineHeight, margin, margin2, marginBottom, marginRight, marginTop, minus, none, padding, padding2, pct, position, px, relative, rem, solid, spaceBetween, textAlign, textDecoration, textTransform, top, uppercase, width, wrap)
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h1, h2, h3, h4, img, li, p, section, span, styled, text, ul)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global as Theme exposing (darkBlue, darkPurple, pink, purple, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
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
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = t SiteTitle
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t PartnersMetaDescription
        , locale = Nothing
        , title = t PartnersTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t PartnersTitle
    , body =
        [ PageTemplate.view
            { title = t PartnersTitle
            , bigText = t PartnersIntroSummary
            , smallText = [ t PartnersIntroDescription ]
            }
            (viewPartners static)
            Nothing
        ]
    }


viewPartners : StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams -> Html msg
viewPartners static =
    section []
        [ div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Filters" ]
        , h3 [ css [ partnersListTitleStyle ] ] [ text "All partners" ]
        , if List.length static.data > 0 then
            ul [ css [ listStyle ] ] (List.map (\partner -> viewPartner partner) static.data)

          else
            p [] [ text (t PartnersListEmpty) ]
        , viewMap
        ]


viewPartner : Data.PlaceCal.Partners.Partner -> Html msg
viewPartner partner =
    li [ css [ listItemStyle ] ]
        [ div [ css [ partnerTopRowStyle ] ]
            [ h4 [ css [ partnerNameStyle ] ]
                [ a [ href (TransRoutes.toAbsoluteUrl (Partner partner.id)), css [ partnerNameLink ] ] [ text partner.name ] ]
            , viewAreaTag partner.areasServed partner.address
            ]
        , div [ css [ partnerBottomRowStyle ] ]
            [ p [ css [ partnerDescriptionStyle ] ]
                [ text partner.summary
                ]
            , span [] [ text "[fFf]" ] --- [fFf] the icon debate...
            ]
        ]


viewMap : Html msg
viewMap =
    div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Map" ]


viewAreaTag :
    List Data.PlaceCal.Partners.ServiceArea
    -> Maybe Data.PlaceCal.Partners.Address
    -> Html msg
viewAreaTag serviceAreas maybeAddress =
    if List.length serviceAreas > 0 then
        ul []
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
        [ withMediaTabletLandscapeUp [ width (calc (pct 50) minus (rem 2)) ]
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
        ]


partnerBottomRowStyle : Style
partnerBottomRowStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , padding2 (rem 0.5) (rem 0)
        , withMediaTabletLandscapeUp [ padding2 (rem 0.75) (rem 0) ]
        ]


partnerNameStyle : Style
partnerNameStyle =
    batch
        [ color white
        , fontSize (rem 1.2)
        , fontStyle italic
        , withMediaTabletPortraitUp [ fontSize (rem 1.5) ]
        ]


partnerNameLink : Style
partnerNameLink =
    batch
        [ textDecoration none
        , color white
        ]


partnerDescriptionStyle : Style
partnerDescriptionStyle =
    batch
        [ fontSize (rem 0.8777)
        , marginRight (rem 1)
        , withMediaTabletPortraitUp [ fontSize (rem 1.2) ]
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , marginBottom (rem 2)
        , backgroundColor purple
        ]
