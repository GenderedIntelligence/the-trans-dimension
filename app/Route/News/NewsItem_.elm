module Route.News.NewsItem_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Articles
import FatalError
import Head
import Helpers.TransRoutes
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
    ()


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : RouteParams -> BackendTask.BackendTask FatalError.FatalError Data
data _ =
    BackendTask.succeed ()


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    let
        article =
            Data.PlaceCal.Articles.articleFromSlug app.routeParams.newsItem app.sharedData.articles app.sharedData.partners
    in
    Theme.PageTemplate.pageMetaTags
        { title = NewsItemTitle article.title
        , description =
            NewsItemMetaDescription article.title (String.join " & " article.partnerIds)
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    let
        article =
            Data.PlaceCal.Articles.articleFromSlug app.routeParams.newsItem app.sharedData.articles app.sharedData.partners
    in
    { title = t (NewsItemTitle article.title)
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "invisible"
            , title = t NewsTitle
            , bigText = { text = article.title, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (Theme.NewsItemPage.viewArticle article)
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
