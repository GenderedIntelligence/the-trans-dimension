module Data.PlaceCal.Events exposing (Event, EventPartner, Realm(..), afterDate, allEventsQuery, emptyEvent, eventFromSlug, eventsData, eventsDecoder, eventsFromDate, eventsFromPartnerId, next4Events, onOrBeforeDate)

import BackendTask
import BackendTask.Custom
import Data.PlaceCal.Api
import FatalError
import Helpers.TransDate as TransDate
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Time


type alias Event =
    { id : String
    , name : String
    , summary : String
    , description : String
    , startDatetime : Time.Posix
    , endDatetime : Time.Posix
    , maybePublisherUrl : Maybe String
    , location : Maybe EventLocation
    , partner : EventPartner
    , maybeGeo : Maybe Geo
    }


type alias EventPartner =
    { name : Maybe String
    , id : String
    , maybeContactDetails : Maybe EventPartnerContact
    , maybeUrl : Maybe String
    }


type alias EventPartnerContact =
    { email : String
    , telephone : String
    }


type alias EventLocation =
    { streetAddress : String
    , postalCode : String
    }


type alias Geo =
    -- Bug: We expect if there is a postcode in the address, these exist.
    -- But, in practice, sometimes they don't see:
    -- https://github.com/geeksforsocialchange/PlaceCal/issues/1639
    { latitude : Maybe String
    , longitude : Maybe String
    }


emptyEvent : Event
emptyEvent =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    , startDatetime = Time.millisToPosix 0
    , endDatetime = Time.millisToPosix 0
    , maybePublisherUrl = Nothing
    , location = Nothing
    , maybeGeo = Nothing
    , partner =
        { name = Nothing
        , id = ""
        , maybeUrl = Nothing
        , maybeContactDetails = Nothing
        }
    }


type Realm
    = Online


eventFromSlug : String -> List Event -> Event
eventFromSlug eventId eventsList =
    List.filter (\event -> event.id == eventId) eventsList
        |> List.head
        |> Maybe.withDefault emptyEvent


eventsFromPartnerId : List Event -> String -> List Event
eventsFromPartnerId eventsList id =
    List.filter (\event -> event.partner.id == id) eventsList


eventsFromDate : List Event -> Time.Posix -> List Event
eventsFromDate eventsList fromDate =
    List.filter
        (\event ->
            TransDate.isSameDay event.startDatetime fromDate
        )
        eventsList


onOrBeforeDate : List Event -> Time.Posix -> List Event
onOrBeforeDate eventsList fromDate =
    List.filter
        (\event ->
            TransDate.isOnOrBeforeDate event.startDatetime fromDate
        )
        eventsList


afterDate : List Event -> Time.Posix -> List Event
afterDate eventsList fromDate =
    List.filter
        (\event ->
            TransDate.isAfterDate event.startDatetime fromDate
        )
        eventsList


next4Events : List Event -> Time.Posix -> List Event
next4Events allEvents fromTime =
    List.take 4 (eventsFromDate allEvents fromTime)



----------------------------
-- DataSource query & decode
----------------------------


eventsData : BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Custom.Error } AllEventsResponse
eventsData =
    Data.PlaceCal.Api.fetchAndCachePlaceCalData "events"
        allEventsQuery
        eventsDecoder


allEventsQuery : Json.Encode.Value
allEventsQuery =
    Json.Encode.object
        [ ( "query"
            -- Note hardcoded to load events from 2022-09-01
          , Json.Encode.string """
            query { eventsByFilter(tagId: 3, fromDate: "2024-01-01 00:00", toDate: "2025-06-15 00:00") {
              id
              name
              summary
              description
              startDate
              endDate
              publisherUrl
              address { streetAddress, postalCode, geo { latitude, longitude } }
              organizer { id }
            } }
            """
          )
        ]


eventsDecoder : Json.Decode.Decoder AllEventsResponse
eventsDecoder =
    Json.Decode.succeed AllEventsResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "eventsByFilter" ] (Json.Decode.list decode)


decode : Json.Decode.Decoder Event
decode =
    Json.Decode.succeed Event
        |> Json.Decode.Pipeline.required "id"
            Json.Decode.string
        |> Json.Decode.Pipeline.required "name"
            Json.Decode.string
        |> Json.Decode.Pipeline.optional "summary"
            Json.Decode.string
            ""
        |> Json.Decode.Pipeline.optional "description"
            Json.Decode.string
            ""
        |> Json.Decode.Pipeline.required "startDate"
            TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.required "endDate"
            TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.optional "publisherUrl"
            (Json.Decode.nullable Json.Decode.string)
            Nothing
        |> Json.Decode.Pipeline.optional "address" (Json.Decode.map Just eventAddressDecoder) Nothing
        |> Json.Decode.Pipeline.requiredAt [ "organizer", "id" ]
            partnerIdDecoder
        |> Json.Decode.Pipeline.optionalAt [ "address", "geo" ] (Json.Decode.map Just geoDecoder) Nothing


eventAddressDecoder : Json.Decode.Decoder EventLocation
eventAddressDecoder =
    Json.Decode.succeed EventLocation
        |> Json.Decode.Pipeline.required "streetAddress" Json.Decode.string
        |> Json.Decode.Pipeline.required "postalCode" Json.Decode.string


partnerIdDecoder : Json.Decode.Decoder EventPartner
partnerIdDecoder =
    Json.Decode.string
        |> Json.Decode.map (\partnerId -> { name = Nothing, id = partnerId, maybeContactDetails = Nothing, maybeUrl = Nothing })


geoDecoder : Json.Decode.Decoder Geo
geoDecoder =
    Json.Decode.succeed Geo
        |> Json.Decode.Pipeline.optional "latitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing
        |> Json.Decode.Pipeline.optional "longitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing


type alias AllEventsResponse =
    { allEvents : List Event }
