module PlaceCalTypes exposing (Event, Partner, Realm(..), emptyEvent, emptyPartner, realmToString)

import Time


type alias Partner =
    { id : String
    , name : String
    , summary : String
    , description : String
    }


emptyPartner : Partner
emptyPartner =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    }


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


realmToString : Event -> String
realmToString event =
    case event.realm of
        Online ->
            "Online"

        Offline ->
            "Offline"
