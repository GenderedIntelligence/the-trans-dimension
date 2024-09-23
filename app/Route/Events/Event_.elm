module Route.Events.Event_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import BackendTask.Custom
import Browser.Dom
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Api
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Effect
import FatalError
import Head
import Json.Encode
import PagesMsg
import RouteBuilder
import Shared
import Task
import Theme.EventPage
import Theme.PageTemplate
import Theme.TransMarkdown
import Time
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { event : String }


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


pages : BackendTask.BackendTask FatalError.FatalError (List RouteParams)
pages =
    BackendTask.map
        (\eventData ->
            eventData.allEvents
                |> List.map (\event -> { event = event.id })
        )
        (Data.PlaceCal.Api.fetchAndCachePlaceCalData
            "events"
            Data.PlaceCal.Events.allEventsQuery
            Data.PlaceCal.Events.eventsDecoder
        )
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    let
        event =
            Data.PlaceCal.Events.eventFromSlug app.routeParams.event app.sharedData.events
    in
    Theme.PageTemplate.pageMetaTags
        { title = EventTitle event.name
        , description = EventMetaDescription event.name event.summary
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    let
        event : Data.PlaceCal.Events.Event
        event =
            Data.PlaceCal.Events.eventFromSlug app.routeParams.event app.sharedData.events

        eventWithPartner : Data.PlaceCal.Events.Event
        eventWithPartner =
            { event | partner = Data.PlaceCal.Partners.eventPartnerFromId app.sharedData.partners event.partner.id }
    in
    { title = t (PageMetaTitle event.name)
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = event.name, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (Theme.EventPage.viewEventInfo eventWithPartner)
            , outerContent = Just (Theme.EventPage.viewButtons event)
            }
        ]
    }
