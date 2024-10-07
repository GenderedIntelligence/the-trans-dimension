module Route.Partners exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import FatalError
import Head
import PagesMsg
import RouteBuilder
import Shared
import Theme.PageTemplate
import Theme.PartnersPage
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
    ()


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed ()


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    Theme.PageTemplate.pageMetaTags
        { title = PartnersTitle
        , description = PartnersMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    { title = t (PageMetaTitle (t PartnersTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t PartnersTitle
            , bigText = { text = t PartnersIntroSummary, node = "p" }
            , smallText = Just [ t PartnersIntroDescription ]
            , innerContent = Just (Theme.PartnersPage.viewPartners app.sharedData.partners)
            , outerContent = Nothing
            }
        ]
    }
