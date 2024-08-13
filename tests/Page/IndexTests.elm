module Page.IndexTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Expect
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html
import Html.Attributes
import Page.Index exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures exposing (sharedModelInit)
import TestUtils exposing (queryFromStyledList)


viewParamsForHome =
    { data =
        { latestNews = List.head TestFixtures.news
        , allEvents = TestFixtures.events
        }
    , path = Path.fromString "/"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing sharedModelInit viewParams).body


suite : Test
suite =
    describe "Home page body"
        [ test "Has expected number of h2 headings" <|
            \_ ->
                viewBodyHtml viewParamsForHome
                    |> Query.findAll [ Selector.tag "h2" ]
                    |> Query.count (Expect.equal 3)
        , test "Has expected content headings & intro text" <|
            \_ ->
                viewBodyHtml viewParamsForHome
                    |> Query.contains
                        [ Html.text (t IndexIntroMessage)
                        , Html.text (t IndexFeaturedHeader)
                        , Html.text (t IndexNewsHeader)
                        ]
        , test "Has 2 links to events page" <|
            \_ ->
                viewBodyHtml viewParamsForHome
                    |> Query.findAll
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl Events))
                        ]
                    |> Query.count (Expect.equal 2)
        , test "Has link to news page" <|
            \_ ->
                viewBodyHtml viewParamsForHome
                    |> Query.find
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl News))
                        ]
                    |> Query.contains [ Html.text (t IndexNewsButtonText) ]
        ]
