module Page.ResourcesTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.Resources exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithResources =
    { data = Fixtures.resources
    , path = Path.fromString "resources"
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
    describe "Resources page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithResources
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text "Resources" ]
        , test "Has 1 list of resources" <|
            \_ ->
                viewBodyHtml viewParamsWithResources
                    |> Query.findAll
                        [ Selector.tag "ul"
                        , Selector.containing
                            [ Selector.tag "li", Selector.tag "h3" ]
                        ]
                    |> Query.count (Expect.equal 1)
        , test "Has 2 resource categories" <|
            \_ ->
                viewBodyHtml viewParamsWithResources
                    |> Query.findAll
                        [ Selector.tag "li"
                        , Selector.containing
                            [ Selector.tag "h3" ]
                        ]
                    |> Query.count (Expect.equal 2)
        , test "Each resource has an title, description & link" <|
            \_ ->
                viewBodyHtml viewParamsWithResources
                    |> Query.findAll
                        [ Selector.tag "li", Selector.containing [ Selector.tag "h4" ] ]
                    |> Query.each
                        (Expect.all
                            [ Query.has
                                [ Selector.tag "h4"
                                , Selector.tag "p"
                                , Selector.tag "a"
                                ]
                            ]
                        )
        , test "Has the expected intro & resource content" <|
            \_ ->
                viewBodyHtml viewParamsWithResources
                    |> Query.contains
                        [ Html.text (t ResourcesIntro)
                        , Html.text "[fFf] Filters!"
                        , Html.text "Resource Category 1"
                        , Html.text "Resource Category 2"
                        , Html.text "A 1 resource"
                        , Html.text "Another 1 resource"
                        , Html.text "A 2 resource"
                        , Html.text "A short description about resource 1 in the first category."
                        , Html.text "A longish description about resource 2 in the first category. This is where we go on and on about the resource. We think it's a good on and will be helpful to many people."
                        , Html.text "A short description about resource 1 in the Second category."
                        , Html.text "https://one.example.com"
                        , Html.text "https://two.example.com"
                        , Html.text "https://three.example.com"
                        ]

        -- [fFf] What do we show if a category is empty?
        -- What do we show if there are no resources?
        ]
