module Route.Partners.Partner_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Browser.Dom
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Effect
import FatalError
import Head
import Helpers.TransRoutes exposing (Route(..))
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Task
import Theme.Global
import Theme.PageTemplate
import Theme.Paginator exposing (Msg(..))
import Theme.PartnerPage
import Time
import UrlPath
import View


type alias Model =
    { filterBy : Theme.Paginator.Filter
    , visibleEvents : List Data.PlaceCal.Events.Event
    , nowTime : Time.Posix
    , viewportWidth : Float
    , urlFragment : Maybe String
    }


type alias Msg =
    Theme.Paginator.Msg


type alias RouteParams =
    { partner : String }


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.preRender
        { data = data
        , pages = pages
        , head = head
        }
        |> RouteBuilder.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions = subscriptions
            }


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app shared =
    let
        urlFragment : Maybe String
        urlFragment =
            Maybe.andThen .fragment app.url

        tasks : List (Effect.Effect Msg)
        tasks =
            [ Task.perform GetTime Time.now
                |> Effect.fromCmd
            , Task.perform GotViewport Browser.Dom.getViewport
                |> Effect.fromCmd
            ]
    in
    ( { filterBy = Theme.Paginator.None
      , visibleEvents = app.data.events
      , nowTime = Time.millisToPosix 0
      , viewportWidth = 320
      , urlFragment = urlFragment
      }
    , Effect.batch
        (case urlFragment of
            Just fragment ->
                tasks
                    ++ [ Browser.Dom.getElement fragment
                            |> Task.andThen (\element -> Browser.Dom.setViewport 0 element.element.y)
                            |> Task.attempt (\_ -> NoOp)
                            |> Effect.fromCmd
                       ]

            Nothing ->
                tasks
        )
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
                    Data.PlaceCal.Events.eventsFromDate app.data.events posix
              }
            , Effect.none
            )

        ClickedAllPastEvents ->
            ( { model
                | filterBy = Theme.Paginator.Past
                , visibleEvents = List.reverse (Data.PlaceCal.Events.onOrBeforeDate app.data.events model.nowTime)
              }
            , Effect.none
            )

        ClickedAllFutureEvents ->
            ( { model
                | filterBy = Theme.Paginator.Future
                , visibleEvents = Data.PlaceCal.Events.afterDate app.data.events model.nowTime
              }
            , Effect.none
            )

        GetTime newTime ->
            ( { model
                | filterBy = Theme.Paginator.Day newTime
                , nowTime = newTime
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate app.data.events newTime
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
subscriptions routeParams path shared model =
    Sub.none


type alias Data =
    { partner : Data.PlaceCal.Partners.Partner
    , events : List Data.PlaceCal.Events.Event
    }


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : RouteParams -> BackendTask.BackendTask FatalError.FatalError Data
data routeParams =
    BackendTask.map2
        (\partnerData eventData ->
            -- There probably a better pattern than succeed with empty.
            -- In theory all will succeed since routes mapped from same list.
            { partner =
                Maybe.withDefault Data.PlaceCal.Partners.emptyPartner
                    ((partnerData.allPartners
                        -- Filter for partner with matching id
                        |> List.filter (\partner -> partner.id == routeParams.partner)
                     )
                        -- There should only be one, so take the head
                        |> List.head
                    )
            , events = Data.PlaceCal.Events.eventsFromPartnerId eventData routeParams.partner
            }
        )
        Data.PlaceCal.Partners.partnersData
        (BackendTask.map (\eventsData -> eventsData.allEvents) Data.PlaceCal.Events.eventsData)
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    Theme.PageTemplate.pageMetaTags
        { title = PartnerTitle app.data.partner.name
        , description = PartnerMetaDescription app.data.partner.name app.data.partner.summary
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared model =
    { title = t (PageMetaTitle app.data.partner.name)
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t PartnersTitle
            , bigText = { text = app.data.partner.name, node = "h3" }
            , smallText = Nothing
            , innerContent =
                Just
                    (Theme.PartnerPage.viewInfo model app.data)
            , outerContent = Just (Theme.Global.viewBackButton (Helpers.TransRoutes.toAbsoluteUrl Partners) (t BackToPartnersLinkText))
            }
        ]
    }


pages : BackendTask.BackendTask FatalError.FatalError (List RouteParams)
pages =
    BackendTask.map
        (\partnerData ->
            partnerData.allPartners
                |> List.map (\partner -> { partner = partner.id })
        )
        Data.PlaceCal.Partners.partnersData
        |> BackendTask.allowFatal
