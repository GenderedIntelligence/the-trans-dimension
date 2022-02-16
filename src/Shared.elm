module Shared exposing (Data, Model, Msg(..), Partner, SharedMsg(..), data, template)

import Browser.Navigation
import DataSource
import Html
import Html.Styled
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Theme
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



-------
-- Data
-------


type alias Data =
    { partners : List Partner }


type alias Partner =
    { id : String
    , name : String
    , summary : String
    , description : String
    }


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
        }


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
            (Theme.containerPage pageView.title ([ Theme.globalStyles ] ++ pageView.body))
    , title = pageView.title
    }
