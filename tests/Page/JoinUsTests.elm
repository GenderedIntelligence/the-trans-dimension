module Page.JoinUsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures exposing (sharedModelInit)
import Expect
import Html
import Page.JoinUs exposing (blankForm, initialFormState, view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithJoinUs =
    { data = ()
    , path = Path.fromString "join-us"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view
            Nothing
            sharedModelInit
            { userInput = blankForm
            , formState = initialFormState
            }
            viewParams
        ).body


suite : Test
suite =
    describe "Join Us page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithJoinUs
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t JoinUsTitle) ]
        , test "Has 8 inputs" <|
            \_ ->
                viewBodyHtml viewParamsWithJoinUs
                    |> Query.findAll [ Selector.tag "input" ]
                    |> Query.count (Expect.equal 8)
        , test "Has 1 textarea" <|
            \_ ->
                viewBodyHtml viewParamsWithJoinUs
                    |> Query.findAll [ Selector.tag "textarea" ]
                    |> Query.count (Expect.equal 1)
        , test "Has a form with expected labels" <|
            \_ ->
                viewBodyHtml viewParamsWithJoinUs
                    |> Query.findAll [ Selector.tag "label" ]
                    |> Expect.all
                        [ Query.count (Expect.equal 9)
                        , Query.index 0 >> Query.has [ Selector.text (t JoinUsFormInputNameLabel) ]
                        , Query.index 1 >> Query.has [ Selector.text (t JoinUsFormInputEmailLabel) ]
                        , Query.index 2 >> Query.has [ Selector.text (t JoinUsFormInputPhoneLabel) ]
                        , Query.index 3 >> Query.has [ Selector.text (t JoinUsFormInputJobLabel) ]
                        , Query.index 4 >> Query.has [ Selector.text (t JoinUsFormInputOrgLabel) ]
                        , Query.index 5 >> Query.has [ Selector.text (t JoinUsFormInputAddressLabel) ]
                        , Query.index 6 >> Query.has [ Selector.text (t JoinUsFormCheckbox1) ]
                        , Query.index 7 >> Query.has [ Selector.text (t JoinUsFormCheckbox2) ]
                        , Query.index 8 >> Query.has [ Selector.text (t JoinUsFormInputMessageLabel) ]
                        ]
        , test "Has a submit button" <|
            \_ ->
                viewBodyHtml viewParamsWithJoinUs
                    |> Query.find [ Selector.tag "form" ]
                    |> Query.contains [ Html.text (t JoinUsFormSubmitButton) ]
        ]
