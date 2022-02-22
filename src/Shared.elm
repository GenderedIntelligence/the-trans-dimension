module Shared exposing (Data, Event, Model, Msg(..), Partner, SharedMsg(..), data, emptyEvent, emptyPartner, template)

import Browser.Navigation
import DataSource
import Html
import Html.Attributes exposing (name)
import Html.Styled
import PageFooter exposing (viewPageFooter)
import PageHeader exposing (viewPageHeader)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Theme
import Time
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg



-------------
-- Data Types
-------------


type alias Data =
    { partners : List Partner
    , events : List Event
    }


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
    , online : Bool
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
    , online = False
    , partnerId = ""
    }



----------------------------
-- Model, Messages & Update
----------------------------


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed
        { partners =
            [ { id = "1"
              , name = "Partner one"
              , summary = "Partner one Info"
              , description = "Partner one intro"
              }
            , { id = "2"
              , name = "Partner two"
              , summary = "Partner two Info"
              , description = "Partner two intro"
              }
            , { id = "3"
              , name = "Partner three"
              , summary = "Partner three Info"
              , description = "Partner three intro"
              }
            , { id = "4"
              , name = "Partner four"
              , summary = "Partner four Info"
              , description = "Partner four intro"
              }
            ]
        , events =
            [ { id = "1"
              , name = "Event 1 name"
              , summary = "A summary of the first event"
              , description = "Longer description of the first event"
              , startDatetime = Time.millisToPosix 1645466400000
              , endDatetime = Time.millisToPosix 1650564000000
              , location = "Venue"
              , online = False
              , partnerId = "1"
              }
            , { id = "2"
              , name = "Event 2 name"
              , summary = "A summary of the second event"
              , description = "Longer description of the second event"
              , startDatetime = Time.millisToPosix 1645448400000
              , endDatetime = Time.millisToPosix 1658408400000
              , location = "Venue"
              , online = False
              , partnerId = "2"
              }
            ]
        }



-------
-- View
-------


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html.Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        Html.Styled.toUnstyled
            (Theme.containerPage pageView.title
                [ View.fontPreload
                , Theme.globalStyles
                , viewPageHeader
                , Html.Styled.main_ [] pageView.body
                , viewPageFooter
                ]
            )
    , title = pageView.title
    }
