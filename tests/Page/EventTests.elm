module Page.EventTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Events exposing (Realm(..))
import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.Events.Event_ exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)
import Time


viewParamsWithEvent =
    { data =
        { id = "1"
        , name = "Event name"
        , description = "Event description"
        , summary = "Event summary"
        , startDatetime = Time.millisToPosix 0
        , endDatetime = Time.millisToPosix 0
        , location = "Event location"
        , realm = Online
        , partnerId = "1"
        }
    , path = Path.fromString "event/1"
    , routeParams = { event = "1" }
    , sharedData =
        { events = Fixtures.events
        , news = Fixtures.news
        }
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "Event page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.findAll [ Selector.tag "h2" ]
                    |> Query.count (Expect.equal 1)
        , test "Has expected h3 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.find [ Selector.tag "h3" ]
                    |> Query.contains [ Html.text "Event name" ]
        , test "Contains Date info" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains [ Html.text "1st January 1970" ]
        , test "Contains time info" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains
                        [ Html.text "12:00am"
                        , Html.text " - "
                        , Html.text "12:00am"
                        ]
        , test "Contains venue type info" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains [ Html.text "Online" ]
        , test "Has event description text" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains [ Html.text "Event description" ]
        , test "Has link to event webpage" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains [ Html.text "link [fFf]" ]
        , test "Contains map" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Map" ]
        , test "Contains link back to events page" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains [ Html.text (t BackToEventsLinkText) ]
        ]
