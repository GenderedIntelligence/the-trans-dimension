module Data.PlaceCal.Events exposing (Event, Realm(..), emptyEvent, eventsData, realmToString)

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
    , location : String

    -- , realm : Realm
    , partnerId : String
    }


emptyEvent : Event
emptyEvent =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    , startDatetime = Time.millisToPosix 0
    , endDatetime = Time.millisToPosix 0
    , location = ""

    -- , realm = Offline
    , partnerId = ""
    }


type Realm
    = Online
    | Offline


realmToString : Realm -> String
realmToString realm =
    case realm of
        Online ->
            "Online"

        Offline ->
            "Offline"



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
              address { postalCode }
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
        |> OptimizedDecoder.Pipeline.requiredAt [ "address", "postalCode" ]
            OptimizedDecoder.string
        -- |> OptimizedDecoder.Pipeline.required "realm"
        --    realmDecoder
        |> OptimizedDecoder.Pipeline.requiredAt [ "organizer", "id" ]
            OptimizedDecoder.string


realmDecoder : OptimizedDecoder.Decoder Realm
realmDecoder =
    OptimizedDecoder.string
        |> OptimizedDecoder.andThen
            (\string ->
                case string of
                    "Online" ->
                        OptimizedDecoder.succeed Online

                    "Offline" ->
                        OptimizedDecoder.succeed Offline

                    _ ->
                        OptimizedDecoder.fail "Invalid realm"
            )


type alias AllEventsResponse =
    { allEvents : List Event }
