module Route.JoinUs exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Browser.Dom
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Events
import Effect exposing (Effect)
import FatalError
import Head
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Task
import Theme.JoinUsPage exposing (Msg(..))
import Theme.PageTemplate
import Time
import UrlPath
import View exposing (View)


type alias Model =
    { userInput : Theme.JoinUsPage.FormInput
    , formState : Theme.JoinUsPage.FormState
    }


type alias Msg =
    Theme.JoinUsPage.Msg


type alias RouteParams =
    {}


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app _ =
    ( { userInput = Theme.JoinUsPage.blankForm
      , formState = Theme.JoinUsPage.Inputting
      }
    , Effect.none
    )


run : Msg -> Effect Msg
run m =
    Task.perform (always m) (Task.succeed ())
        |> Effect.fromCmd


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg )
update app _ msg ({ userInput } as model) =
    case msg of
        UpdateName newString ->
            let
                oldField =
                    userInput.name

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | name = newField } }, Effect.none )

        UpdateEmail newString ->
            let
                oldField =
                    model.userInput.email

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | email = newField } }, Effect.none )

        UpdatePhone newString ->
            let
                oldField =
                    userInput.phone

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | phone = newField } }, Effect.none )

        UpdateJob newString ->
            let
                oldField =
                    userInput.job

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | job = newField } }, Effect.none )

        UpdateOrg newString ->
            let
                oldField =
                    userInput.org

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | org = newField } }, Effect.none )

        UpdateAddress newString ->
            let
                oldField =
                    userInput.address

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | address = newField } }, Effect.none )

        UpdateRingBack newBool ->
            let
                oldField =
                    userInput.ringBack

                newField =
                    { oldField | value = newBool }
            in
            ( { model | userInput = { userInput | ringBack = newField } }, Effect.none )

        UpdateMoreInfo newBool ->
            let
                oldField =
                    userInput.moreInfo

                newField =
                    { oldField | value = newBool }
            in
            ( { model | userInput = { userInput | moreInfo = newField } }, Effect.none )

        UpdateMessage newString ->
            let
                oldField =
                    userInput.message

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | message = newField } }, Effect.none )

        ErrorName errorType ->
            let
                oldField =
                    userInput.name

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | name = newField } }, Effect.none )

        ErrorEmail errorType ->
            let
                oldField =
                    userInput.email

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | email = newField } }, Effect.none )

        Theme.JoinUsPage.ErrorMessage errorType ->
            let
                oldField =
                    userInput.message

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | message = newField } }, Effect.none )

        ClickSend ->
            ( model, Effect.batch (List.map (\message -> run message) (Theme.JoinUsPage.validateForm model.userInput)) )

        SendEmail ->
            ( model, Theme.JoinUsPage.emailPostRequest (Theme.JoinUsPage.emailBody model.userInput) |> Effect.fromCmd )

        SetFormState newState ->
            ( { model | formState = newState }, Effect.none )

        ReceiveEmailResponse result ->
            case result of
                Ok _ ->
                    ( { userInput = Theme.JoinUsPage.blankForm, formState = Theme.JoinUsPage.Sent }, Effect.none )

                Err _ ->
                    ( { model | formState = Theme.JoinUsPage.SendingError }, Effect.none )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildWithLocalState
            { init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


type alias Data =
    ()


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed ()


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = JoinUsTitle
        , description = JoinUsMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View (PagesMsg.PagesMsg Msg)
view _ _ model =
    { title = t (PageMetaTitle (t JoinUsTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "pink"
            , title = t JoinUsTitle
            , bigText = { text = t JoinUsSubtitle, node = "p" }
            , smallText = Just [ t JoinUsDescription ]
            , innerContent = Just (Theme.JoinUsPage.view model)
            , outerContent = Nothing
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
