module Page.AboutTests exposing (..)

import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.About exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithAbout =
    { data = { title = "About Page Test Title", body = [] }
    , path = Path.fromString "about"
    , routeParams = {}
    , sharedData =
        { partners = Fixtures.partners
        , events = Fixtures.events
        , news = Fixtures.news
        }
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "About page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithAbout
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text "About Page Test Title" ]
        ]
