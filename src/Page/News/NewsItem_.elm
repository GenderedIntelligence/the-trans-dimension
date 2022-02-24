module Page.News.NewsItem_ exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, auto, backgroundColor, batch, block, bold, center, color, display, fontSize, fontWeight, inlineBlock, margin, margin2, margin4, marginBottom, marginTop, none, num, padding, pct, rem, textAlign, textDecoration, width)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Html.Styled exposing (Html, a, article, div, h2, h3, li, main_, p, section, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { newsItem : String }


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
            sharedData.news
                |> List.map (\newsItem -> { newsItem = newsItem.id })
        )
        Shared.data


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\sharedData ->
            Maybe.withDefault Shared.emptyNews
                ((sharedData.news
                    |> List.filter (\newsItem -> newsItem.id == routeParams.newsItem)
                 )
                    |> List.head
                )
        )
        Shared.data


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
        , description = t (NewsItemDescription static.data.title)
        , locale = Nothing
        , title = t (NewsItemTitle static.data.title)
        }
        |> Seo.website


type alias Data =
    Shared.News


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Shared.News RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body =
        [ viewHeader (t NewsTitle), viewArticle static.data, viewGoBack ]
    }


viewHeader : String -> Html msg
viewHeader headerText =
    section [] [ h2 [ css [ Theme.Global.pageHeadingStyle ] ] [ text headerText ] ]


viewArticle : Shared.News -> Html msg
viewArticle newsItem =
    article []
        [ h3 [ css [ articleHeaderStyle ] ] [ text newsItem.title ]
        , p [ css [ articleMetaStyle ] ] [ text ("By " ++ newsItem.author) ]
        , time [ css [ articleMetaStyle ] ] [ text ("Published on " ++ TransDate.humanTimeFromPosix newsItem.datetime) ]
        , div [ css [ articleContentStyle ] ] [ text "[fFf] [cCc] News paragraphs etc go here" ]
        ]


viewGoBack : Html msg
viewGoBack =
    a [ href "/news", css [ goBackStyle ] ] [ text (t NewsItemReturnButton) ]


articleHeaderStyle : Style
articleHeaderStyle =
    batch
        [ textAlign center
        , fontSize (rem 2)
        ]


articleMetaStyle : Style
articleMetaStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , display block
        ]


articleContentStyle : Style
articleContentStyle =
    batch
        [ margin2 (rem 2) (rem 0) ]


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
        ]
