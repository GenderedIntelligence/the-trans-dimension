module Page.PrivacyTests exposing (..)

import Data.TestFixtures as Fixtures
import Html
import Page.Privacy exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithPrivacy =
    { data = { title = "Privacy Page Test Title", subtitle = "Subtitle for privacy page test.", body = [] }
    , path = Path.fromString "privacy"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing Fixtures.sharedModelInit viewParams).body


suite : Test
suite =
    describe "Privacy page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithPrivacy
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text "Privacy Page Test Title" ]
        ]
