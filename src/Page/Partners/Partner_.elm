module Page.Partners.Partner_ exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, auto, backgroundColor, batch, block, bold, center, color, display, fontSize, fontWeight, hover, margin2, marginBottom, none, padding, pct, rem, textAlign, textDecoration, width)
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h2, h3, p, section, text)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
import Theme.PageTemplate as PageTemplate
import Theme.TransMarkdown
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { partner : String }


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
        (\partnerData ->
            partnerData.allPartners
                |> List.map (\partner -> { partner = partner.id })
        )
        Data.PlaceCal.Partners.partnersData


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\partnerData ->
            -- There probably a better patter than succeed with empty.
            -- In theory all will succeed since routes mapped from same list.
            Maybe.withDefault Data.PlaceCal.Partners.emptyPartner
                ((partnerData.allPartners
                    -- Filter for partner with matching id
                    |> List.filter (\partner -> partner.id == routeParams.partner)
                 )
                    -- There should only be one, so take the head
                    |> List.head
                )
        )
        Data.PlaceCal.Partners.partnersData


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t (PartnerMetaDescription static.data.name)
        , locale = Nothing
        , title = t (PartnerTitle static.data.name)
        }
        |> Seo.website


type alias Data =
    Data.PlaceCal.Partners.Partner


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data.PlaceCal.Partners.Partner RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.name
    , body =
        [ PageTemplate.view { title = t PartnersTitle, bigText = static.data.name, smallText = [] }
            (Just (div []
                [ viewInfo static.data
                , a [ href (TransRoutes.toAbsoluteUrl Partners), css [ goBackStyle ] ] [ text (t BackToPartnersLinkText) ]
                ]
            ))
            Nothing
        ]
    }


viewInfo : Data.PlaceCal.Partners.Partner -> Html msg
viewInfo partner =
    section []
        [ p [] (Theme.TransMarkdown.markdownToHtml partner.description)
        , p [ css [ featurePlaceholderStyle ] ] [ text "[fFf] partner contact info (from API?)" ]
        , div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Map" ]
        , div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Partner event listing?" ]
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ fontWeight bold
        , marginBottom (rem 2)
        ]


partnerHeadingStyle : Style
partnerHeadingStyle =
    batch
        [ textAlign center
        , fontSize (rem 2)
        ]


goBackStyle : Style
goBackStyle =
    batch
        [ backgroundColor Theme.Global.darkBlue
        , color Theme.Global.white
        , textDecoration none
        , padding (rem 1)
        , display block
        , width (pct 25)
        , margin2 (rem 2) auto
        , textAlign center
        , hover [ backgroundColor Theme.Global.blue, color Theme.Global.black ]
        ]
