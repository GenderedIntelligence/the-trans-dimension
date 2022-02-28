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


viewParamsWithEvents =
    { data = Fixtures.events
    , path = Path.fromString "events"
    , routeParams = {}
    , sharedData =
        { partners = Fixtures.partners
        , events = Fixtures.events
        , news = Fixtures.news
        }
    }


viewParamsWithoutEvents =
    { data = []
    , path = Path.fromString "events"
    , routeParams = {}
    , sharedData =
        { partners = Fixtures.partners
        , events = []
        , news = Fixtures.news
        }
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "Events page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithEvents
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t EventsTitle) ]
        , test "Contains filter controls" <|
            \_ ->
                viewBodyHtml viewParamsWithEvents
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Event filters" ]
        , test "Has pagination by day/week" <|
            \_ ->
                viewBodyHtml viewParamsWithEvents
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Pagination by day/week" ]
        , test "Contains a list of upcoming events" <|
            \_ ->
                viewBodyHtml viewParamsWithEvents
                    |> Query.find [ Selector.tag "ul" ]
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "Does not contain list if there are no events" <|
            \_ ->
                viewBodyHtml viewParamsWithoutEvents
                    |> Query.hasNot [ Selector.tag "ul" ]
        ]
