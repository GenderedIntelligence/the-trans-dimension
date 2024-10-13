module Route.Events exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Browser.Dom
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Events
import Effect
import FatalError
import Head
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Task
import Theme.Page.Events
import Theme.PageTemplate
import Theme.Paginator exposing (Msg(..))
import Time
import UrlPath
import View exposing (View)


type alias Model =
    { filterBy : Theme.Paginator.Filter
    , visibleEvents : List Data.PlaceCal.Events.Event
    , nowTime : Time.Posix
    , viewportWidth : Float
    }


type alias Msg =
    Theme.Paginator.Msg


type alias RouteParams =
    {}


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app _ =
    ( { filterBy = Theme.Paginator.None
      , visibleEvents = Data.PlaceCal.Events.eventsWithPartners app.sharedData.events app.sharedData.partners
      , nowTime = Time.millisToPosix 0
      , viewportWidth = 320
      }
    , Effect.batch
        [ Task.perform GetTime Time.now |> Effect.fromCmd
        , Task.perform GotViewport Browser.Dom.getViewport |> Effect.fromCmd
        ]
    )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg )
update app _ msg model =
    case msg of
        ClickedDay posix ->
            ( { model
                | filterBy = Theme.Paginator.Day posix
                , visibleEvents =
                    Data.PlaceCal.Events.eventsWithPartners (Data.PlaceCal.Events.eventsFromDate app.sharedData.events posix) app.sharedData.partners
              }
            , Effect.none
            )

        ClickedAllPastEvents ->
            ( { model
                | filterBy = Theme.Paginator.Past
                , visibleEvents = Data.PlaceCal.Events.eventsWithPartners (List.reverse (Data.PlaceCal.Events.onOrBeforeDate app.sharedData.events model.nowTime)) app.sharedData.partners
              }
            , Effect.none
            )

        ClickedAllFutureEvents ->
            ( { model
                | filterBy = Theme.Paginator.Future
                , visibleEvents = Data.PlaceCal.Events.eventsWithPartners (Data.PlaceCal.Events.afterDate app.sharedData.events model.nowTime) app.sharedData.partners
              }
            , Effect.none
            )

        GetTime newTime ->
            ( { model
                | filterBy = Theme.Paginator.Day newTime
                , nowTime = newTime
                , visibleEvents =
                    Data.PlaceCal.Events.eventsWithPartners (Data.PlaceCal.Events.eventsFromDate app.sharedData.events newTime) app.sharedData.partners
              }
            , Effect.none
            )

        ScrollRight ->
            ( model
            , Task.attempt (\_ -> NoOp)
                (Theme.Paginator.scrollPagination Theme.Paginator.Right model.viewportWidth)
                |> Effect.fromCmd
            )

        ScrollLeft ->
            ( model
            , Task.attempt (\_ -> NoOp)
                (Theme.Paginator.scrollPagination Theme.Paginator.Left model.viewportWidth)
                |> Effect.fromCmd
            )

        GotViewport viewport ->
            ( { model | viewportWidth = Maybe.withDefault model.viewportWidth (Just viewport.scene.width) }, Effect.none )

        NoOp ->
            ( model, Effect.none )


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
            , update = update
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
        { title = EventsTitle
        , description = EventsMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View (PagesMsg.PagesMsg Msg)
view _ _ model =
    { title = t (PageMetaTitle (t EventsTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = t EventsSummary, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (Theme.Page.Events.viewEvents model)
            , outerContent = Nothing
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
