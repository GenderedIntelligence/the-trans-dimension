module Page.News exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, batch, margin2, rem)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, h2, h3, li, main_, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
import View exposing (View)
import Theme.PageTemplate as PageTemplate
import Html.Styled exposing (div)


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
    List Shared.News


data : DataSource (List Shared.News)
data =
    DataSource.map (\sharedData -> sharedData.news) Shared.data


head :
    StaticPayload Data RouteParams
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
        , description = t NewsDescription
        , locale = Nothing
        , title = t NewsTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Shared.News) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t NewsTitle
    , body =
        [ PageTemplate.view { title = (t NewsTitle), bigText = (t NewsDescription), smallText = []} Nothing (Just (div [] [ viewNewsList static
        , viewPagination ]))]
    }

viewNewsList : StaticPayload (List Shared.News) RouteParams -> Html Msg
viewNewsList news =
    section []
        [ if List.length news.data == 0 then
            p [] [ text (t NewsEmptyText) ]

          else
            ul [] (List.map (\newsItem -> viewNewsItem newsItem) news.data)
        ]


viewNewsItem : Shared.News -> Html msg
viewNewsItem newsItem =
    li [ css [ newsItemStyle ] ]
        [ article []
            [ h3 [] [ text newsItem.title ]
            , p []
                [ time [] [ text (TransDate.humanDateFromPosix newsItem.datetime) ]
                , text " by [cCc]"
                , span [] [ text newsItem.author ]
                ]
            , p [] [ text newsItem.summary ]
            , a [ href (TransRoutes.toAbsoluteUrl (NewsItem newsItem.id)) ] [ text (t NewsReadMore) ]
            ]
        ]


viewPagination : Html msg
viewPagination =
    ul [] [ text "[fFf] News pagination" ]


newsItemStyle : Style
newsItemStyle =
    batch
        [ margin2 (rem 2) (rem 0) ]
