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
    { data =
        { main = 
            { title = "About Page Test Title"
            , subtitle = "Test subtitle here."
            , body = []
            }
        , accessibility = 
            { title = "Accessibility"
            , subtitle = "Accessibility is good for everyone"
            , body = []
            }
        , makers = 
            [ { name = "Makername", url = "google.com", logo = "logo.png", body = [] } ]
        , placecal = 
            { title = "PlaceCal lives here"
            , subtitleimg = "img.jpeg"
            , subtitleimgalt = "PlaceCal logo"
            , body = []
            }
        }
    , path = Path.fromString "about"
    , routeParams = {}
    , sharedData = ()
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
