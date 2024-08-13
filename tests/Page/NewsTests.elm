module Page.NewsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Expect
import Html
import Page.News exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures exposing (sharedModelInit)
import TestUtils exposing (queryFromStyledList)


viewParamsWithNews =
    { data = TestFixtures.news
    , path = Path.fromString "news"
    , routeParams = {}
    , sharedData = ()
    }


viewParamsWithoutNews =
    { data = []
    , path = Path.fromString "news"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing sharedModelInit viewParams).body


suite : Test
suite =
    describe "News page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithNews
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t NewsTitle) ]
        , test "Contains a list of news" <|
            \_ ->
                viewBodyHtml viewParamsWithNews
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.first
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "Contains expected news content" <|
            \_ ->
                viewBodyHtml viewParamsWithNews
                    |> Query.contains
                        [ Html.text "Some news"
                        , Html.text "21st February 2022"
                        , Html.text "Nunc augue erat, ullamcorper et nunc nec, placerat rhoncus nulla. Quisque nec sollicitudin turpis. Etiam risus dolor, ullamcorper vitae consectetur"
                        , Html.text "Article Author1"
                        , Html.text "Article Author1, Article Author2"
                        , Html.text "Big news!"
                        , Html.text "22nd February 2022"
                        ]
        , test "Does not contain list if there are no events" <|
            \_ ->
                viewBodyHtml viewParamsWithoutNews
                    |> Query.findAll [ Selector.tag "p" ]
                    |> Query.index 0
                    |> Query.contains [ Html.text (t NewsEmptyText) ]
        ]
