module Data.PlaceCal.Events exposing (Event, Realm(..), emptyEvent, eventsData, realmToString)

import Api
import DataSource
import DataSource.Http
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
    , realm : Realm
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
    , realm = Offline
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
            query { eventConnection { edges {
                node {
                    id
                    name
                    summary
                    description
                    startDatetime
                    endDatetime
                    location
                    realm
                    partnerId
            } } } }
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
        |> OptimizedDecoder.Pipeline.requiredAt [ "data", "eventConnection", "edges" ] (OptimizedDecoder.list decode)


decode : OptimizedDecoder.Decoder Event
decode =
    OptimizedDecoder.succeed Event
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "id" ]
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "name" ]
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optionalAt [ "node", "summary" ]
            OptimizedDecoder.string
            ""
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "description" ]
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "startDatetime" ]
            posixDecoder
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "endDatetime" ]
            posixDecoder
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "location" ]
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "realm" ]
            realmDecoder
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "partnerId" ]
            OptimizedDecoder.string


posixDecoder : OptimizedDecoder.Decoder Time.Posix
posixDecoder =
    OptimizedDecoder.int |> OptimizedDecoder.map Time.millisToPosix


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
