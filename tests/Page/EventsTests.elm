module Page.EventsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures exposing (sharedModelInit)
import Expect
import Html
import Page.Events exposing (Filter(..), view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)
import Time


viewParamsWithEvents =
    { data = Fixtures.events
    , path = Path.fromString "events"
    , routeParams = {}
    , sharedData = ()
    }


eventsModel =
    { filterBy = Future
    , visibleEvents = Fixtures.events
    , nowTime = Time.millisToPosix 0
    , viewportWidth = 1920
    }


eventsModelNoEvents =
    { filterBy = Future
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

                        -- , Html.text (t EventsFilterLabelAll)
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
        ]
