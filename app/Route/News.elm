module Route.News exposing (Model, Msg, RouteParams, route, Data, ActionData)

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
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Theme.NewsPage
import Theme.PageTemplate
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


route : RouteBuilder.StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildNoState
            { view = view }


type alias Data =
    List Data.PlaceCal.Articles.Article


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.map2
        (\articleData partnerData ->
            List.map
                (\article ->
                    { article | partnerIds = Data.PlaceCal.Partners.partnerNamesFromIds partnerData article.partnerIds }
                )
                articleData.allArticles
        )
        Data.PlaceCal.Articles.articlesData
        (BackendTask.map (\partnersData -> partnersData.allPartners) Data.PlaceCal.Partners.partnersData)
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    Theme.PageTemplate.pageMetaTags
        { title = NewsTitle
        , description = NewsDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    { title = t (PageMetaTitle (t NewsTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t NewsTitle
            , bigText = { text = t NewsDescription, node = "h3" }
            , smallText = Nothing
            , innerContent = Nothing
            , outerContent = Just (Theme.NewsPage.viewNewsList app.data)
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
