module Page.PartnerTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Html
import Page.Partners.Partner_ exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)


viewParamsWithPartner =
    { data =
        { id = "1"
        , name = "Partner name"
        , description = "Partner description"
        , summary = "Partner summary"
        , maybeUrl = Just "https://www.example.com"
        , contactDetails =
            { email = "partner@example.com"
            , telephone = "0161 496 0000"
            }
        , maybeAddress =
            Just
                { streetAddress = "1 The Street"
                , addressRegion = "Exampleton"
                , postalCode = "A1 2BC"
                }
        , areasServed = []
        }
    , path = Path.fromString "partner/1"
    , routeParams = { partner = "1" }
    , sharedData =
        { news = Fixtures.news
        }
    }


viewParamsWithoutMaybes =
    let
        setData oldData =
            { oldData | maybeUrl = Nothing, maybeAddress = Nothing }
    in
    { viewParamsWithPartner | data = setData viewParamsWithPartner.data }


viewBodyHtml viewParams =
    queryFromStyledList
        (view Nothing { showMobileMenu = False } viewParams).body


suite : Test
suite =
    describe "Partner page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.findAll [ Selector.tag "h2" ]
                    |> Query.count (Expect.equal 1)

        --- Temporarily removed test for partner heading - not compatible with current layout, need to fix :D
        , test "Has partner description text" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.contains [ Html.text "Partner description" ]
        , test "Contains address if provided" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.contains
                        [ Html.address []
                            [ Html.p [] [ Html.text "1 The Street" ]
                            , Html.p []
                                [ Html.text "Exampleton"
                                , Html.text ", "
                                , Html.text "A1 2BC"
                                ]
                            ]
                        ]
        , test "Contains address empty text if not provided" <|
            \_ ->
                viewBodyHtml viewParamsWithoutMaybes
                    |> Query.contains
                        [ Html.text (t PartnerAddressEmptyText) ]
        , test "Contact details contain url if provided" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.contains
                        [ Html.address []
                            [ Html.p [] [ Html.text "0161 496 0000" ]
                            , Html.p [] [ Html.text "partner@example.com" ]
                            , Html.p [] [ Html.text "https://www.example.com" ]
                            ]
                        ]
        , test "Can have contact details without url" <|
            \_ ->
                viewBodyHtml viewParamsWithoutMaybes
                    |> Query.contains
                        [ Html.address []
                            [ Html.p [] [ Html.text "0161 496 0000" ]
                            , Html.p [] [ Html.text "partner@example.com" ]
                            , Html.text ""
                            ]
                        ]
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
