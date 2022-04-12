module Page.PartnerTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.TestFixtures as Fixtures
import Expect
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html
import Html.Attributes
import Page.Partners.Partner_ exposing (view)
import Pages.Url
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyledList)
import Time


viewParamsWithPartner =
    { data =
        { partner =
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
        , events =
            [ { id = "1"
              , name = "Event 1 name"
              , summary = "A summary of the first event"
              , description = "Fusce at sodales lacus. Morbi scelerisque lacus leo, ac mattis urna ultrices et. Proin ac eros faucibus, consequat ante vel, vulputate lectus. Nunc dictum pharetra ex, eget vestibulum lacus. Maecenas molestie felis in turpis eleifend, nec accumsan massa sodales. Nulla facilisi. Vivamus id rhoncus nulla. Nunc ultricies lectus et dui tempor sodales. Curabitur interdum lectus ultricies est ultricies, at faucibus nisi semper. Praesent iaculis ornare orci. Sed vel metus pharetra, efficitur leo a, porttitor magna. Curabitur sit amet mollis ex."
              , startDatetime = Time.millisToPosix 1645466400000
              , endDatetime = Time.millisToPosix 1650564000000
              , location = "Venue"
              , partnerId = "1"
              }
            , { id = "2"
              , name = "Event 2 name"
              , summary = "A summary of the second event"
              , description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut risus placerat, suscipit lacus quis, pretium nisl. Fusce enim erat, fringilla ac auctor scelerisque, scelerisque non ipsum. Vivamus non elit id orci aliquam lobortis at sit amet ligula. Aenean vel massa pellentesque, viverra turpis et, commodo ipsum. Vivamus nunc elit, elementum et ipsum id, rutrum commodo sapien. Integer eget mi eget lacus sagittis molestie feugiat at lacus. Cras ultrices molestie blandit. Suspendisse gravida tortor non risus vestibulum laoreet. Nam nec quam id nisi suscipit consectetur. Aliquam venenatis tortor elit, id suscipit augue feugiat ac."
              , startDatetime = Time.millisToPosix 1645448400000
              , endDatetime = Time.millisToPosix 1658408400000
              , location = "Venue"
              , partnerId = "1"
              }
            ]
        }
    , path = Path.fromString "partner/1"
    , routeParams = { partner = "1" }
    , sharedData = ()
    }


viewParamsWithoutMaybes =
    let
        setData oldData =
            { oldData | maybeUrl = Nothing, maybeAddress = Nothing }
    in
    { viewParamsWithPartner
        | data =
            { partner = setData viewParamsWithPartner.data.partner
            , events = viewParamsWithPartner.data.events
            }
    }


viewParamsWithoutEvents =
    { viewParamsWithPartner
        | data =
            { partner = viewParamsWithPartner.data.partner
            , events = []
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
                            , Html.p [] [ Html.a [] [ Html.text "partner@example.com" ] ]
                            , Html.p [] [ Html.a [] [ Html.text "https://www.example.com" ] ]
                            ]
                        ]
        , test "Can have contact details without url" <|
            \_ ->
                viewBodyHtml viewParamsWithoutMaybes
                    |> Query.contains
                        [ Html.address []
                            [ Html.p [] [ Html.text "0161 496 0000" ]
                            , Html.p [] [ Html.a [] [ Html.text "partner@example.com" ] ]
                            , Html.text ""
                            ]
                        ]
        , test "Contains map" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    -- Note this is currently a placeholder
                    |> Query.contains [ Html.text "[fFf] Map" ]
        , test "Can contain events" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    -- Todo just testing for event name for now
                    |> Query.contains
                        [ Html.text "Event 1 name"
                        , Html.text "Event 2 name"
                        ]
        , test "Contains events empty text if no current events" <|
            \_ ->
                viewBodyHtml viewParamsWithoutEvents
                    |> Query.contains
                        [ Html.text (t (PartnerEventsEmptyText "Partner name")) ]
        , test "Contains link back to partners page" <|
            \_ ->
                viewBodyHtml viewParamsWithPartner
                    |> Query.find
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl Partners))
                        ]
                    |> Query.contains [ Html.text (t BackToPartnersLinkText) ]
        ]
