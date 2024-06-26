module Page.PartnerTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html
import Html.Attributes
import Page.Partners.Partner_ exposing (view)
import Path
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures exposing (sharedModelInit)
import TestUtils exposing (queryFromStyledList)
import Theme.Paginator as Paginator
import Time


viewParamsWithPartner =
    { data =
        { partner =
            { id = "1"
            , name = "Partner name"
            , description = "Partner description"
            , summary = "Partner summary"
            , maybeUrl = Just "https://www.example.com"
            , maybeContactDetails =
                Just
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
            , maybeGeo = Nothing
            , maybeLogo = Nothing
            }
        , events =
            [ { id = "1"
              , name = "Event 1 name"
              , summary = "A summary of the first event"
              , description = "Fusce at sodales lacus. Morbi scelerisque lacus leo, ac mattis urna ultrices et. Proin ac eros faucibus, consequat ante vel, vulputate lectus. Nunc dictum pharetra ex, eget vestibulum lacus. Maecenas molestie felis in turpis eleifend, nec accumsan massa sodales. Nulla facilisi. Vivamus id rhoncus nulla. Nunc ultricies lectus et dui tempor sodales. Curabitur interdum lectus ultricies est ultricies, at faucibus nisi semper. Praesent iaculis ornare orci. Sed vel metus pharetra, efficitur leo a, porttitor magna. Curabitur sit amet mollis ex."
              , startDatetime = Time.millisToPosix 1645466400000
              , endDatetime = Time.millisToPosix 1650564000000
              , maybePublisherUrl = Just "https://example.com/publisher/url/1"
              , location = Just { streetAddress = "1 The Street", postalCode = "N2 2AA" }
              , partner = { id = "1", name = Nothing, maybeUrl = Nothing, maybeContactDetails = Nothing }
              , maybeGeo = Nothing
              }
            , { id = "2"
              , name = "Event 2 name"
              , summary = "A summary of the second event"
              , description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut risus placerat, suscipit lacus quis, pretium nisl. Fusce enim erat, fringilla ac auctor scelerisque, scelerisque non ipsum. Vivamus non elit id orci aliquam lobortis at sit amet ligula. Aenean vel massa pellentesque, viverra turpis et, commodo ipsum. Vivamus nunc elit, elementum et ipsum id, rutrum commodo sapien. Integer eget mi eget lacus sagittis molestie feugiat at lacus. Cras ultrices molestie blandit. Suspendisse gravida tortor non risus vestibulum laoreet. Nam nec quam id nisi suscipit consectetur. Aliquam venenatis tortor elit, id suscipit augue feugiat ac."
              , startDatetime = Time.millisToPosix 1645448400000
              , endDatetime = Time.millisToPosix 1658408400000
              , maybePublisherUrl = Just "https://example.com/publisher/url/1"
              , location = Just { streetAddress = "1 The Street", postalCode = "N2 2AA" }
              , maybeGeo = Nothing
              , partner = { id = "1", name = Nothing, maybeUrl = Nothing, maybeContactDetails = Nothing }
              }
            ]
        }
    , path = Path.fromString "partner/1"
    , routeParams = { partner = "1" }
    , sharedData = ()
    }


viewParamsWithoutUrlOrAddress =
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


viewParamsWithoutContactDetailsOrUrl =
    let
        setData oldData =
            { oldData | maybeUrl = Nothing, maybeContactDetails = Nothing }
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


eventsModel =
    { filterBy = Paginator.None
    , visibleEvents = TestFixtures.events
    , nowTime = Time.millisToPosix 0
    , viewportWidth = 1920
    , urlFragment = Nothing
    }


viewBodyHtml localModel viewParams =
    queryFromStyledList
        (view Nothing sharedModelInit localModel viewParams).body


suite : Test
suite =
    describe "Partner page body"
        [ test "Has expected h2 heading" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    |> Query.findAll [ Selector.tag "h2" ]
                    |> Query.index 0
                    |> Query.contains [ Html.text (t PartnersTitle) ]
        , test "Has expected h3 heading" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    |> Query.findAll [ Selector.tag "h3" ]
                    |> Query.index 0
                    |> Query.contains [ Html.text "Partner name" ]
        , test "Has partner description text" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    |> Query.contains [ Html.text "Partner description" ]
        , test "Contains address if provided" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    |> Query.has
                        [ Selector.tag "address"
                        , Selector.containing
                            [ Selector.tag "p"
                            , Selector.containing
                                [ Selector.text "1 The Street" ]
                            ]
                        ]
        , test "Contains address empty text if not provided" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithoutUrlOrAddress
                    |> Query.contains
                        [ Html.text (t PartnerAddressEmptyText) ]
        , test "Contains contact empty text if no details or url" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithoutContactDetailsOrUrl
                    |> Query.contains
                        [ Html.text (t PartnerContactsEmptyText) ]
        , test "Contact details contain url if provided" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    |> Query.has
                        [ Selector.tag "address"
                        , Selector.containing
                            [ Selector.tag "p"
                            , Selector.containing
                                [ Selector.tag "a"
                                , Selector.containing
                                    [ Selector.text "www.example.com"
                                    ]
                                , Selector.attribute (Html.Attributes.href "https://www.example.com")
                                ]
                            ]
                        ]

        -- Commented out as reminder to add map test
        -- , test "Contains map" <|
        --     \_ ->
        --         viewBodyHtml viewParamsWithPartner
        --             -- Note this is currently a placeholder
        --             |> Query.contains [ Html.text "[fFf] Map" ]
        , test "Can contain events" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    -- Todo just testing for event name for now
                    |> Query.contains
                        [ Html.text "Event 1 name"
                        , Html.text "Event 2 name"
                        ]
        , test "Contains events empty text if no current events" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithoutEvents
                    |> Query.contains
                        [ Html.text (t (PartnerEventsEmptyText "Partner name")) ]
        , test "Contains link back to partners page" <|
            \_ ->
                viewBodyHtml eventsModel viewParamsWithPartner
                    |> Query.find
                        [ Selector.tag "a"
                        , Selector.attribute (Html.Attributes.href (TransRoutes.toAbsoluteUrl Partners))
                        ]
                    |> Query.contains [ Html.text (t BackToPartnersLinkText) ]
        ]
