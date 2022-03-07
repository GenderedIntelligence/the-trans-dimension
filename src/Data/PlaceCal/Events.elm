module Data.PlaceCal.Events exposing (Event, Realm(..), emptyEvent, realmToString)

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
