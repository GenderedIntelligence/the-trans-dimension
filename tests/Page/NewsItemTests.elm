module Page.NewsItemTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCalTypes exposing (Realm(..))
import Data.TestFixtures as Fixtures
import Expect
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html
import Html.Attributes
import Page.News.NewsItem_ exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)
import Time


viewParamsWithNewsItem =
    { data =
        { id = "1"
        , title = "News Item Title"
        , summary = "News item summary"
        , body = "The news item body. Some more lines about news."
        , datetime = Time.millisToPosix 0
        , author = "Joe News"
        }
    , path = Path.fromString "news/1"
    , routeParams = { newsItem = "1" }
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
                    |> Query.contains [ Html.text "Published on 1st January 1970" ]
        , test "Contains byline" <|
            \_ ->
                viewBodyHtml viewParamsWithNewsItem
                    |> Query.contains [ Html.text "By Joe News" ]
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
