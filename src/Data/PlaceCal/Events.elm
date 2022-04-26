module Data.PlaceCal.Events exposing (Event, EventPartner, Realm(..), emptyEvent, eventsData, eventsFromPartnerId)

import Api
import DataSource
import DataSource.Http
import Helpers.TransDate as TransDate
import Json.Encode
import OptimizedDecoder
import OptimizedDecoder.Pipeline
import Pages.Secrets
import Time


type alias Event =
    { id : String
    , name : String
    , summary : String
    , description : String
    , startDatetime : Time.Posix
    , endDatetime : Time.Posix
    , location : EventLocation

    -- , realm : Realm
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
    { streetAddress : Maybe String
    , postCode : Maybe String
    }


type alias Geo =
    { latitude : String
    , longitude : String
    }


emptyEvent : Event
emptyEvent =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    , startDatetime = Time.millisToPosix 0
    , endDatetime = Time.millisToPosix 0
    , location = { streetAddress = Nothing, postCode = Nothing }

    -- , realm = Offline
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


eventsFromPartnerId : List Event -> String -> List Event
eventsFromPartnerId eventsList id =
    List.filter (\event -> event.partner.id == id) eventsList



----------------------------
-- DataSource query & decode
----------------------------


eventsData : DataSource.DataSource AllEventsResponse
eventsData =
    DataSource.Http.request (Pages.Secrets.succeed allEventsPlaceCalRequest)
        eventsDecoder


allEventsQuery : Json.Encode.Value
allEventsQuery =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string """
            query { eventsByFilter(tagId: 3) {
              id
              name
              summary
              description
              startDate
              endDate
              address { streetAddress, postalCode, geo { latitude, longitude } }
              organizer { id }
            } }
            """
          )
        ]


allEventsPlaceCalRequest : DataSource.Http.RequestDetails
allEventsPlaceCalRequest =
    { url = Api.placeCalApiUrl
    , method = "POST"
    , headers = []
    , body = DataSource.Http.jsonBody allEventsQuery
    }


eventsDecoder : OptimizedDecoder.Decoder AllEventsResponse
eventsDecoder =
    OptimizedDecoder.succeed AllEventsResponse
        |> OptimizedDecoder.Pipeline.requiredAt [ "data", "eventsByFilter" ] (OptimizedDecoder.list decode)


decode : OptimizedDecoder.Decoder Event
decode =
    OptimizedDecoder.succeed Event
        |> OptimizedDecoder.Pipeline.required "id"
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "name"
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optional "summary"
            OptimizedDecoder.string
            ""
        |> OptimizedDecoder.Pipeline.required "description"
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "startDate"
            TransDate.isoDateStringDecoder
        |> OptimizedDecoder.Pipeline.required "endDate"
            TransDate.isoDateStringDecoder
        |> OptimizedDecoder.Pipeline.required "address" eventAddressDecoder
        |> OptimizedDecoder.Pipeline.requiredAt [ "organizer", "id" ]
            partnerIdDecoder
        |> OptimizedDecoder.Pipeline.optionalAt [ "address", "geo" ] (OptimizedDecoder.map Just geoDecoder) Nothing


eventAddressDecoder : OptimizedDecoder.Decoder EventLocation
eventAddressDecoder =
    OptimizedDecoder.succeed EventLocation
        |> OptimizedDecoder.Pipeline.optional "streetAddress" (OptimizedDecoder.map Just OptimizedDecoder.string) Nothing
        |> OptimizedDecoder.Pipeline.optional "postalCode" (OptimizedDecoder.map Just OptimizedDecoder.string) Nothing


partnerIdDecoder : OptimizedDecoder.Decoder EventPartner
partnerIdDecoder =
    OptimizedDecoder.string
        |> OptimizedDecoder.map (\partnerId -> { name = Nothing, id = partnerId, maybeContactDetails = Nothing, maybeUrl = Nothing })


geoDecoder : OptimizedDecoder.Decoder Geo
geoDecoder =
    OptimizedDecoder.succeed Geo
        |> OptimizedDecoder.Pipeline.required "latitude" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "longitude" OptimizedDecoder.string


type alias AllEventsResponse =
    { allEvents : List Event }
