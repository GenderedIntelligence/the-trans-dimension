module Shared exposing (Data, Model, Msg, News, SharedMsg, data, emptyNews, template)

import Browser.Navigation
import Data.PlaceCal.Events
import Data.TestFixtures as Fixtures
import DataSource
import Html
import Html.Attributes
import Html.Styled
import Http
import Json.Encode
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
    , newsletterSignupEmail : String
    , newsletterSignupResponse : Maybe String
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
      , newsletterSignupEmail = ""
      , newsletterSignupResponse = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        -- Header
        ToggleMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )

        -- Footer
        SubmitNewsletterSignupForm ->
            ( { model | newsletterSignupResponse = Nothing }
            , postNewsletterSignupRequest model.newsletterSignupEmail
            )

        SetNewsletterSignupEmail email ->
            ( { model | newsletterSignupEmail = email }, Cmd.none )

        GotNewsletterSignupResponse (Ok response) ->
            ( { model | newsletterSignupResponse = Just response }, Cmd.none )

        GotNewsletterSignupResponse (Err error) ->
            ( { model | newsletterSignupResponse = Nothing }, Cmd.none )

        -- Shared
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



-----------------
-- Update helpers
-----------------


postNewsletterSignupRequest : String -> Cmd Msg
postNewsletterSignupRequest email =
    Http.post
        { --url = "https://static.mailerlite.com/webforms/submit/g2r6z4"
          url = "https://example.com"
        , body =
            Http.jsonBody
                (Json.Encode.object
                    [ ( "email", Json.Encode.string email )
                    , ( "ml-submit", Json.Encode.int 1 )
                    , ( "anticsrf", Json.Encode.bool True )
                    ]
                )
        , expect = Http.expectString GotNewsletterSignupResponse
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
