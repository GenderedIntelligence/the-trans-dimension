module Shared exposing (Data, Model, Msg(..), News, SharedMsg(..), data, emptyNews, partnersData, template)

import Browser.Navigation
import Data.PlaceCalTypes as PlaceCalTypes
import Data.TestFixtures as Fixtures
import DataSource
import DataSource.Http
import Html
import Html.Attributes exposing (name)
import Html.Styled
import Json.Decode
import Json.Encode
import OptimizedDecoder
import OptimizedDecoder.Pipeline
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Theme.Global
import Theme.PageFooter exposing (viewPageFooter)
import Theme.PageHeader exposing (viewPageHeader)
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
    { partners : List PlaceCalTypes.Partner
    , events : List PlaceCalTypes.Event
    , news : List News
    }


type alias News =
    { id : String
    , title : String
    , summary : String
    , body : String
    , datetime : Time.Posix
    , author : String
    }


emptyNews : News
emptyNews =
    { id = ""
    , title = ""
    , summary = ""
    , body = ""
    , datetime = Time.millisToPosix 0
    , author = ""
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



--------------
-- DataSources
--------------


placeCalApiUrl : String
placeCalApiUrl =
    "https://placecal.org/graphql"


allPartnersQuery : Json.Encode.Value
allPartnersQuery =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string "query { allPartners { id, name, description, summary } }"
          )
        ]



--"{\"query\": \"query { allPartners { id, name, description } }\"}"


allPartnersPlaceCalRequest =
    { url = placeCalApiUrl
    , method = "POST"
    , headers = []
    , body = DataSource.Http.jsonBody allPartnersQuery
    }


partnersData : DataSource.DataSource AllPartnersResponse
partnersData =
    DataSource.Http.request (Pages.Secrets.succeed allPartnersPlaceCalRequest)
        partnersDecoder


partnersDecoder =
    OptimizedDecoder.succeed AllPartnersResponse
        |> OptimizedDecoder.Pipeline.requiredAt [ "data", "allPartners" ] (OptimizedDecoder.list decodePartner)


decodePartner =
    OptimizedDecoder.succeed PlaceCalTypes.Partner
        |> OptimizedDecoder.Pipeline.required "id" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "name" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optional "summary" OptimizedDecoder.string ""
        |> OptimizedDecoder.Pipeline.required "description" OptimizedDecoder.string


type alias AllPartnersResponse =
    { allPartners : List PlaceCalTypes.Partner }


data : DataSource.DataSource Data
data =
    DataSource.succeed
        { partners = Fixtures.partners
        , events = Fixtures.events
        , news = Fixtures.news
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
            (Theme.Global.containerPage pageView.title
                [ View.fontPreload
                , Theme.Global.globalStyles
                , viewPageHeader
                , Html.Styled.main_ [] pageView.body
                , viewPageFooter
                ]
            )
    , title = pageView.title
    }
