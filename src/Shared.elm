module Shared exposing (Data, Model, Msg, News, SharedMsg, data, emptyNews, template)

import Browser.Navigation
import Data.PlaceCal.Events
import Data.TestFixtures as Fixtures
import DataSource
import Html
import Html.Attributes
import Html.Styled
import Messages exposing (Msg(..), SharedMsg(..))
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
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



-------------
-- Data Types
-------------


type alias Data =
    { news : List News
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


type alias Msg =
    Messages.Msg


type alias SharedMsg =
    Messages.SharedMsg


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

        ToggleMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed
        { news = Fixtures.news
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
                , viewPageHeader model.showMobileMenu |> Html.Styled.map toMsg
                , Html.Styled.main_ [] pageView.body
                , viewPageFooter
                ]
            )
    , title = pageView.title
    }
