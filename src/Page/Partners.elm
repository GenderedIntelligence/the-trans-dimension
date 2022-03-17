module Page.Partners exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, backgroundColor, batch, block, bold, borderRadius, center, color, display, displayFlex, flexWrap, fontSize, fontStyle, fontWeight, hover, inline, int, italic, justifyContent, lineHeight, margin, margin2, marginBottom, marginTop, none, padding, padding2, pct, position, px, relative, rem, spaceBetween, textAlign, textDecoration, top, width, wrap)
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h1, h2, h3, img, li, p, section, text, ul)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global as Theme exposing (darkBlue, pink, white, withMediaTabletPortraitUp)
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
        [ PageTemplate.view { title = t PartnersTitle, bigText = t PartnersIntroSummary, smallText = [ t PartnersIntroDescription ] } (viewPartners static)
        ]
    }


viewPartners : StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams -> Html msg
viewPartners static =
    section []
        [ div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Filters" ]
        , if List.length static.data > 0 then
            ul [ css [ listStyle ] ] (List.map (\partner -> viewPartner partner) static.data)

          else
            p [] [ text (t PartnersListEmpty) ]
        , viewMap
        ]


viewPartner : Data.PlaceCal.Partners.Partner -> Html msg
viewPartner partner =
    li [ css [ listItemStyle ] ]
        [ h3 []
            [ text partner.name ]
        , p []
            [ text partner.summary
            , a [ href (TransRoutes.toAbsoluteUrl (Partner partner.id)), css [ readMoreStyle ] ] [ text (t PartnersLinkToPartner) ]
            ]
        ]


viewMap : Html msg
viewMap =
    div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Map" ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , marginBottom (rem 2)
        ]


readMoreStyle : Style
readMoreStyle =
    batch
        [ display block
        , backgroundColor darkBlue
        , color white
        , textDecoration none
        , padding (rem 0.5)
        , marginTop (rem 1)
        , hover [ backgroundColor pink, color darkBlue ]
        ]


listStyle : Style
listStyle =
    batch
        [ displayFlex
        , flexWrap wrap
        , justifyContent spaceBetween
        ]


listItemStyle : Style
listItemStyle =
    batch
        [ margin (rem 1)
        , width (pct 30)
        , textAlign center
        ]
