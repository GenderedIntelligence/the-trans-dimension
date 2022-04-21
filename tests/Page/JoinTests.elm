module Page.JoinTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Html.Attributes
import Page.Join exposing (view, blankForm)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithJoin =
    { data = ()
    , path = Path.fromString "join"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view
            Nothing
            { showMobileMenu = False }
            { userInput = blankForm }
            viewParams
        ).body


suite : Test
suite =
    describe "Join page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t JoinTitle) ]
        , test "Has 8 inputs" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.findAll [ Selector.tag "input" ]
                    |> Query.count (Expect.equal 8)
        , test "Has 1 textarea" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.findAll [ Selector.tag "textarea" ]
                    |> Query.count (Expect.equal 1)
        , test "Has a form with expected labels" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.findAll [ Selector.tag "label" ]
                    |> Expect.all
                        [ Query.count (Expect.equal 9), Query.index 0 >> Query.has [ Selector.text (t JoinFormInputNameLabel) ]
                        , Query.index 1 >> Query.has [ Selector.text (t JoinFormInputEmailLabel) ]
                        , Query.index 2 >> Query.has [ Selector.text (t JoinFormInputPhoneLabel) ]                    
                        , Query.index 3 >> Query.has [ Selector.text (t JoinFormInputJobLabel) ]
                        , Query.index 4 >> Query.has [ Selector.text (t JoinFormInputOrgLabel) ]
                        , Query.index 5 >> Query.has [ Selector.text (t JoinFormInputAddressLabel) ]
                        , Query.index 6 >> Query.has [ Selector.text (t JoinFormCheckbox1) ]
                        , Query.index 7 >> Query.has [ Selector.text (t JoinFormCheckbox2) ]
                        , Query.index 8 >> Query.has [ Selector.text (t JoinFormInputMessageLabel) ]
                        ]
        , test "Has a submit button" <|
            \_ ->
                viewBodyHtml viewParamsWithJoin
                    |> Query.find [ Selector.tag "form" ]
                    |> Query.contains [ Html.text (t JoinFormSubmitButton)  ]
        ]
