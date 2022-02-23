module Page.PartnerTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Expect
import Html
import Page.Partners.Partner_ exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures as Fixtures
import TestUtils exposing (queryFromStyledList)


viewParamsWithPartner =
    { data =
        { id = "1"
        , name = "Partner name"
        , description = "Partner description"
        , summary = "Partner summary"
        }
    , path = Path.fromString "partner/1"
    , routeParams = { partner = "1" }
    , sharedData =
        { partners = Fixtures.partners
        , events = Fixtures.events
        }
    }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "Partner page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.find [ Selector.tag "h2" ]
                    |> Query.contains [ Html.text "Partner name" ]
        , test "Has expected h3 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    -- Note this is a placeholder. H2 contains partner name.
                    -- Uncertain what content h3 should have
                    |> Query.findAll [ Selector.tag "h3" ]
                    |> Query.count (Expect.equal 1)
        , test "Has partner description text" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.contains [ Html.text "Partner description" ]
        , test "Contains contact info" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] partner contact info (from API?)" ]
        , test "Contains map" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Map" ]
        , test "Contains link back to partners page" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.find [ Selector.tag "a" ]
                    |> Query.contains [ Html.text (t BackToPartnersLinkText) ]
        ]
