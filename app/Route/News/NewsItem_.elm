module Route.News.NewsItem_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Articles
import Data.PlaceCal.Partners
import FatalError
import Head
import Helpers.TransRoutes
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Theme.NewsItemPage
import Theme.PageTemplate
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { newsItem : String }


route : RouteBuilder.StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { data = data, pages = pages, head = head }
        |> RouteBuilder.buildNoState
            { view = view }


type alias Data =
    Data.PlaceCal.Articles.Article


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : RouteParams -> BackendTask.BackendTask FatalError.FatalError Data
data routeParams =
    BackendTask.map2
        (\articlesData partnersData ->
            Maybe.withDefault Data.PlaceCal.Articles.emptyArticle
                ((articlesData.allArticles
                    |> List.filter (\newsItem -> Helpers.TransRoutes.stringToSlug newsItem.title == routeParams.newsItem)
                 )
                    |> List.head
                )
                |> partnerIdsToNames partnersData
        )
        Data.PlaceCal.Articles.articlesData
        (BackendTask.map (\partnersData -> partnersData.allPartners) Data.PlaceCal.Partners.partnersData)
        |> BackendTask.allowFatal


partnerIdsToNames :
    List Data.PlaceCal.Partners.Partner
    -> Data.PlaceCal.Articles.Article
    -> Data.PlaceCal.Articles.Article
partnerIdsToNames partnersData newsItem =
    { newsItem | partnerIds = Data.PlaceCal.Partners.partnerNamesFromIds partnersData newsItem.partnerIds }


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    Theme.PageTemplate.pageMetaTags
        { title = NewsItemTitle app.data.title
        , description = NewsItemMetaDescription app.data.title (String.join " & " app.data.partnerIds)
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    { title = t (NewsItemTitle app.data.title)
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "invisible"
            , title = t NewsTitle
            , bigText = { text = app.data.title, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (Theme.NewsItemPage.viewArticle app.data)
            , outerContent = Nothing
            }
        ]
    }


pages : BackendTask.BackendTask FatalError.FatalError (List RouteParams)
pages =
    BackendTask.map
        (\articlesData ->
            articlesData.allArticles
                |> List.map
                    (\newsItem ->
                        { newsItem = Helpers.TransRoutes.stringToSlug newsItem.title
                        }
                    )
        )
        Data.PlaceCal.Articles.articlesData
        |> BackendTask.allowFatal
