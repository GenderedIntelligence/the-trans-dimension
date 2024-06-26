module Page.EventTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Expect
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html
import Html.Attributes
import Page.Events.Event_ exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures exposing (sharedModelInit)
import TestUtils exposing (queryFromStyledList)
import Time


viewParamsWithEvent =
    { data =
        { id = "1"
        , name = "Event name"
        , description = "Event description"
        , summary = "Event summary"
        , startDatetime = Time.millisToPosix 1645448400000
        , endDatetime = Time.millisToPosix 1645455600000
        , maybePublisherUrl = Nothing
        , location = Nothing
        , maybeGeo = Nothing
        , partner =
            { id = "1"
            , name = Just "Partner one"
            , maybeContactDetails = Just { telephone = "999", email = "partner@partner.com" }
            , maybeUrl = Just "https://google.com"
            }
        }
    , path = Path.fromString "event/1"
    , routeParams = { event = "1" }
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing sharedModelInit viewParams).body


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
                    |> Query.contains [ Html.text "21st February 2022" ]
        , test "Contains time info" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains
                        [ Html.text "1:00pm"
                        , Html.text " - "
                        , Html.text "3:00pm"
                        ]

        -- , test "Contains venue type info" <|
        --     \_ ->
        --         viewBodyHtml viewParamsWithEvent
        --             |> Query.contains [ Html.text "Online" ]
        , test "Has event description text" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.contains [ Html.text "Event description" ]

        -- Commented out the below because I'm not sure we have that feature on the backend?
        -- , test "Has link to event webpage" <|
        --     \_ ->
        --         viewBodyHtml viewParamsWithEvent
        --             |> Query.contains [ Html.text "link [fFf]" ]
        -- Commented out as reminder to add map test
        -- , test "Contains map" <|
        --     \_ ->
        --         viewBodyHtml viewParamsWithEvent
        --             -- Note this is currently a placeholder
        --             |> Query.contains [ Html.text "[fFf] Map" ]
        , test "Contains link back to events page" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.find
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl Events))
                        ]
                    |> Query.contains [ Html.text (t BackToEventsLinkText) ]
        , test "Contains link back to events section of partner page" <|
            \_ ->
                viewBodyHtml viewParamsWithEvent
                    |> Query.find
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl (Partner viewParamsWithEvent.data.partner.id) ++ "#events"))
                        ]
                    |> Query.contains [ Html.text (t (BackToPartnerEventsLinkText viewParamsWithEvent.data.partner.name)) ]
        ]
