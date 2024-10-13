module Route.JoinUs exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Effect
import FatalError
import Head
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Theme.JoinUsPage
import Theme.PageTemplate
import UrlPath
import View exposing (View)


type alias Model =
    Theme.JoinUsPage.Model


type alias Msg =
    Theme.JoinUsPage.Msg


type alias RouteParams =
    {}


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init _ _ =
    ( { userInput = Theme.JoinUsPage.blankForm
      , formState = Theme.JoinUsPage.Inputting
      }
    , Effect.none
    )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildWithLocalState
            { init = init
            , view = view
            , update = Theme.JoinUsPage.update
            , subscriptions = subscriptions
            }


type alias Data =
    ()


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed ()


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = JoinUsTitle
        , description = JoinUsMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View (PagesMsg.PagesMsg Msg)
view _ _ model =
    { title = t (PageMetaTitle (t JoinUsTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t JoinUsTitle
            , bigText = { text = t JoinUsSubtitle, node = "p" }
            , smallText = Just [ t JoinUsDescription ]
            , innerContent = Just (Theme.JoinUsPage.view model)
            , outerContent = Nothing
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
