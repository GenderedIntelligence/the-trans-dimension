module Page.PartnersTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.Partners exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithPartners =
    { data = Fixtures.partners
    , path = Path.fromString "partners"
    , routeParams = {}
    , sharedData = ()
    }


viewParamsWithoutPartners =
    { data = []
    , path = Path.fromString "partners"
    , routeParams = {}
    , sharedData = ()
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "Partners page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text (t PartnersTitle) ]
        , test "Has intro text" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.contains [ Html.text (t PartnersIntroSummary) ]
        , test "Contains a list of all partners" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.first
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 4)
        , test "Displays abbreviated name of service area if exists" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.contains [ Html.text "Central Ldn" ]
        , test "Displays name for service area if no abbreviated name" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.has [ Selector.text "Birmingham" ]
        , test "Displays tag for all service areas" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.has
                        [ Selector.tag "ul"
                        , Selector.containing
                            [ Selector.tag "li"
                            , Selector.containing
                                [ Selector.tag "span", Selector.containing [ Selector.text "Birmingham" ] ]
                            , Selector.tag "li"
                            , Selector.containing
                                [ Selector.tag "span", Selector.containing [ Selector.text "London" ] ]
                            ]
                        ]
        , test "Does not display name for service area if has abbreviated name" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.hasNot [ Selector.text "Central London" ]
        , test "Displays postal code if no service area" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.has
                        [ Selector.tag "li"
                        , Selector.containing [ Selector.text "SE1" ]
                        ]
        , test "Does not display postal code if has service area" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    |> Query.hasNot [ Selector.text "WC1N" ]
        , test "Does not contain list if there are no partners" <|
            \_ ->
                viewBodyHtml viewParamsWithoutPartners
                    |> Query.hasNot [ Selector.tag "ul" ]
        , test "Contains filter controls" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Filters" ]
        , test "Contains map" <|
            \_ ->
                viewBodyHtml viewParamsWithPartners
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Map" ]
        ]
