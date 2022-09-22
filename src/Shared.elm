module Shared exposing (Data, Model, Msg, template)

import Browser.Navigation
import DataSource
import Html
import Html.Styled
import Messages exposing (Msg(..))
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Task
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
    ()



----------------------------
-- Model, Messages & Update
----------------------------


type alias Msg =
    Messages.Msg


type alias Model =
    { showMobileMenu : Bool
    , showBetaBanner : Bool
    , nowTime : Time.Posix
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
    ( { showMobileMenu = False
      , showBetaBanner = True
      , nowTime = Time.millisToPosix 0
      }
    , Task.perform GetTime Time.now
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        GetTime newTime ->
            ( { model | nowTime = newTime }, Cmd.none )

        -- Header
        ToggleMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )

        HideBetaBanner ->
            ( { model | showBetaBanner = False }, Cmd.none )

        -- Shared
        SharedMsg _ ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()



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
                , View.plausibleTracker
                , Theme.Global.globalStyles
                , viewPageHeader page
                    { showMobileMenu = model.showMobileMenu
                    , showBetaBanner = model.showBetaBanner
                    }
                    |> Html.Styled.map toMsg
                , Html.Styled.main_ [] pageView.body
                , viewPageFooter
                ]
            )
    , title = pageView.title
    }
