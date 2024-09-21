module Route.Events exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Browser.Dom
import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, calc, center, color, column, display, displayFlex, em, firstChild, flexDirection, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, hover, important, int, italic, justifyContent, lastChild, letterSpacing, lineHeight, margin, margin2, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, maxWidth, minus, none, paddingBottom, pct, px, rem, row, rowReverse, solid, spaceBetween, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Effect
import FatalError
import Head
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled
import Html.Styled.Attributes exposing (css, href)
import Pages.PageUrl exposing (PageUrl)
import PagesMsg
import RouteBuilder
import Shared
import Task
import Theme.EventsPage
import Theme.Global exposing (borderTransition, colorTransition, introTextLargeStyle, pink, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate
import Theme.Paginator exposing (Filter(..), Msg(..))
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
init app shared =
    ( { filterBy = Theme.Paginator.None
      , visibleEvents = app.sharedData.events
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
update app shared msg model =
    case msg of
        ClickedDay posix ->
            ( { model
                | filterBy = Theme.Paginator.Day posix
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate app.sharedData.events posix
              }
            , Effect.none
            )

        ClickedAllPastEvents ->
            ( { model
                | filterBy = Theme.Paginator.Past
                , visibleEvents = List.reverse (Data.PlaceCal.Events.onOrBeforeDate app.sharedData.events model.nowTime)
              }
            , Effect.none
            )

        ClickedAllFutureEvents ->
            ( { model
                | filterBy = Theme.Paginator.Future
                , visibleEvents = Data.PlaceCal.Events.afterDate app.sharedData.events model.nowTime
              }
            , Effect.none
            )

        GetTime newTime ->
            ( { model
                | filterBy = Theme.Paginator.Day newTime
                , nowTime = newTime
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate app.sharedData.events newTime
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


addPartnerNamesToEvents : List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Partners.Partner -> List Data.PlaceCal.Events.Event
addPartnerNamesToEvents events partners =
    List.map
        (\event ->
            { event
                | partner =
                    setPartnerName event.partner (Data.PlaceCal.Partners.partnerNameFromId partners event.partner.id)
            }
        )
        events


setPartnerName : Data.PlaceCal.Events.EventPartner -> Maybe String -> Data.PlaceCal.Events.EventPartner
setPartnerName oldEventPartner partnerName =
    { oldEventPartner | name = partnerName }


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head static =
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
view app shared model =
    { title = t (PageMetaTitle (t EventsTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = t EventsSummary, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (Theme.EventsPage.viewEvents model)
            , outerContent = Nothing
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
