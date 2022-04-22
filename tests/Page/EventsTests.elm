module Page.EventsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.Events exposing (view)
import Pages.Url
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
    { filterByDay = Nothing
    , visibleEvents = Fixtures.events
    , nowTime = Time.millisToPosix 0
    }


eventsModelNoEvents =
    { filterByDay = Nothing
    , visibleEvents = []
    , nowTime = Time.millisToPosix 0
    }


viewParamsWithoutEvents =
    { data = []
    , path = Path.fromString "events"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml localModel viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } localModel viewParams).body


suite : Test
suite =
    describe "Events page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t EventsTitle) ]
        , test "Contains filter controls" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Event filters" ]
        , test "Has pagination by day/week" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithEvents
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.first
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 8)
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
                    |> Query.contains [ Html.text (t EventsEmptyText) ]
        ]
