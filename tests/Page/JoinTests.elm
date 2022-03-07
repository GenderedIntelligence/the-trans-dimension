module Page.JoinTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Html.Attributes
import Page.Join exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithJoin =
    { data = ()
    , path = Path.fromString "join"
    , routeParams = {}
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
    describe "Join page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t JoinTitle) ]
        , test "Has 5 inputs" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.findAll [ Selector.tag "input" ]
                    |> Query.count (Expect.equal 4)
        , test "Has 1 textarea" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.findAll [ Selector.tag "textarea" ]
                    |> Query.count (Expect.equal 1)
        , test "Has a form with expected labels" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.findAll [ Selector.tag "label" ]
                    |> Query.keep (Selector.tag "span")
                    |> Expect.all
                        [ Query.index 0 >> Query.has [ Selector.text (t JoinFormInputNameLabel ++ ":") ]
                        , Query.index 1 >> Query.has [ Selector.text (t JoinFormInputTitleLabel ++ ":") ]
                        , Query.index 2 >> Query.has [ Selector.text (t JoinFormInputOrgLabel ++ ":") ]
                        , Query.index 3 >> Query.has [ Selector.text (t JoinFormInputContactLabel ++ ":") ]
                        , Query.index 4 >> Query.has [ Selector.text (t JoinFormInputMessageLabel ++ ":") ]
                        ]
        , test "Has a submit button" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.find [ Selector.tag "form" ]
                    |> Query.contains [ Html.button [ Html.Attributes.type_ "submit" ] [ Html.text (t JoinFormSubmitButton) ] ]
        ]
