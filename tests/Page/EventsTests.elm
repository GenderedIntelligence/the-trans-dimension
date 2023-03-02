module Page.EventsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Expect
import Html
import Page.Events exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures exposing (sharedModelInit)
import TestUtils exposing (queryFromStyledList)
import Theme.Paginator as Paginator
import Time


viewParamsWithEvents =
    { data = TestFixtures.events
    , path = Path.fromString "events"
    , routeParams = {}
    , sharedData = ()
    }


eventsModel =
    { filterBy = Paginator.None
    , visibleEvents = TestFixtures.events
    , nowTime = Time.millisToPosix 0
    , viewportWidth = 1920
    }


eventsModelNoEvents =
    { filterBy = Paginator.None
    , visibleEvents = []
    , nowTime = Time.millisToPosix 0
    , viewportWidth = 1920
    }

eventsModelNoPreviousEvents =
    { filterBy = Paginator.Past
    , visibleEvents = []
    , nowTime = Time.millisToPosix 0
    , viewportWidth = 1920
    }


viewParamsWithoutEvents =
    { data = []
    , path = Path.fromString "events"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml localModel viewParams =
    queryFromStyledList
        (view Nothing sharedModelInit localModel viewParams).body


suite : Test
suite =
    describe "Events page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t EventsTitle) ]
        , test "Has pagination by day/week" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.first
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 7)
        , test "Has pagination by day/week with expected labels" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.first
                    |> Query.contains
                        [ Html.text (t EventsFilterLabelToday)
                        , Html.text (t EventsFilterLabelTomorrow)
                        , Html.text "Sat 03 Jan"
                        , Html.text "Sun 04 Jan"
                        , Html.text "Mon 05 Jan"
                        , Html.text "Tue 06 Jan"
                        , Html.text "Wed 07 Jan"
                        ]
        , test "Contains a list of upcoming events" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.index 1
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "Contains empty text if there are no events" <|
            \_ ->
                viewBodyHtml eventsModelNoEvents viewParamsWithoutEvents
                    |> Query.contains [ Html.text (t EventsEmptyTextAll) ]
        , test "Contains previous events empty text if there are no previous events" <|
            \_ ->
                viewBodyHtml eventsModelNoPreviousEvents viewParamsWithoutEvents
                    |> Query.contains [ Html.text (t PreviousEventsEmptyTextAll) ]
        ]
