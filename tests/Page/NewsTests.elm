module Page.NewsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.News exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithNews =
    { data = Fixtures.news
    , path = Path.fromString "news"
    , routeParams = {}
    , sharedData =
        { news = Fixtures.news
        }
    }


viewParamsWithoutNews =
    { data = []
    , path = Path.fromString "news"
    , routeParams = {}
    , sharedData =
        { news = []
        }
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "News page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithNews
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t NewsTitle) ]
        , test "Has pagination" <|
            \_ ->
                viewBodyHtml viewParamsWithNews
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.index 1
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] News pagination" ]
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
                        , Html.text "News news news"
                        , Html.text "1st January 1970"
                        , Html.text "GFSC"
                        , Html.text "Big news!"
                        , Html.text "Lots of news"
                        , Html.text "2nd January 1970"
                        ]
        , test "Does not contain list if there are no events" <|
            \_ ->
                viewBodyHtml viewParamsWithoutNews
                    |> Query.find [ Selector.tag "p" ]
                    |> Query.contains [ Html.text (t NewsEmptyText) ]
        ]
