module Page.NewsItemTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures exposing (sharedModelInit)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html
import Html.Attributes
import Page.News.NewsItem_ exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)
import Time


viewParamsWithNewsItem =
    { data =
        { title = "News Item Title"
        , body = "The news item body. Some more lines about news."
        , publishedDatetime = Time.millisToPosix 5140800000
        , partnerIds = [ "Article Author" ]
        , maybeImage = Nothing
        }
    , path = Path.fromString "news/news-item-title"
    , routeParams = { newsItem = "news-item-title" }
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing sharedModelInit viewParams).body


suite : Test
suite =
    describe "News Item page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t NewsTitle) ]
        , test "Has expected h3 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.find [ Selector.tag "h3" ]
                    |> Query.contains [ Html.text "News Item Title" ]
        , test "Contains Date info" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.contains [ Html.text "1st March 1970" ]
        , test "Contains byline" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.contains [ Html.text "Article Author" ]
        , test "Contains an article" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.contains [ Html.text "The news item body. Some more lines about news." ]
        , test "Does not contain the summary" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.hasNot [ Selector.text "News item summary" ]
        , test "Has link to news listing" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.find
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl News))
                        ]
                    |> Query.contains [ Html.text (t NewsItemReturnButton) ]
        ]
