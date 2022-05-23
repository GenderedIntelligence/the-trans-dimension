module Page.JoinUs exposing (Data, Model, Msg, blankForm, initialFormState, page, view)

import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, auto, batch, block, borderBox, boxSizing, calc, center, color, column, display, displayFlex, em, flexDirection, flexShrink, flexWrap, fontSize, fontWeight, height, important, int, justifyContent, letterSpacing, lineHeight, margin, margin2, marginRight, marginTop, maxWidth, minHeight, minus, padding2, pct, pseudoElement, px, rem, row, spaceBetween, textAlign, textTransform, uppercase, width, wrap)
import Data.TestFixtures exposing (news)
import DataSource exposing (DataSource)
import Head
import Html.Styled exposing (Html, button, div, form, h1, input, label, p, span, text, textarea)
import Html.Styled.Attributes exposing (css, placeholder, type_, value)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Encode
import List exposing (isEmpty)
import Page exposing (PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Shared
import Task
import Theme.Global exposing (pink, pinkButtonOnDarkBackgroundStyle, textInputErrorStyle, textInputStyle, viewCheckbox, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import View exposing (View)


type FormInputType
    = Text
    | Email
    | PhoneNumber


type FormRequired
    = Required
    | Optional


type FormError
    = FieldRequired
    | WrongFormat


type alias FormInput =
    { name : FormInputField
    , email : FormInputField
    , phone : FormInputField
    , job : FormInputField
    , org : FormInputField
    , address : FormInputField
    , ringBack : Checkbox
    , moreInfo : Checkbox
    , message : FormInputField
    }


type alias FormInputField =
    { value : String
    , error : Maybe FormError
    , inputType : FormInputType
    , required : FormRequired
    }


type FormState
    = Inputting
    | ValidationError
    | Sending
    | Sent
    | SendingError


type alias Checkbox =
    { value : Bool
    , required : FormRequired
    }


type alias Model =
    { userInput : FormInput
    , formState : FormState
    }


initialFormState : FormState
initialFormState =
    Inputting


blankForm : FormInput
blankForm =
    { name =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , email =
        { value = ""
        , error = Nothing
        , inputType = Email
        , required = Required
        }
    , phone =
        { value = ""
        , error = Nothing
        , inputType = PhoneNumber
        , required = Required
        }
    , job =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , org =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , address =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , ringBack =
        { value = False
        , required = Optional
        }
    , moreInfo =
        { value = False
        , required = Optional
        }
    , message =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    }


validateForm : FormInput -> List Msg
validateForm formData =
    let
        fieldsToError =
            [ { isEmpty = formData.name.value == "", errorCmd = ErrorName FieldRequired }
            , { isEmpty = formData.email.value == "", errorCmd = ErrorEmail FieldRequired }
            , { isEmpty = formData.message.value == "", errorCmd = ErrorMessage FieldRequired }
            ]
                |> List.filter (\field -> field.isEmpty)
                |> List.map (\field -> field.errorCmd)
    in
    if List.isEmpty fieldsToError then
        [ SendEmail, SetFormState Sending ]

    else
        List.append [ SetFormState ValidationError ] fieldsToError


emailPostRequest : Json.Encode.Value -> Cmd Msg
emailPostRequest bodyValue =
    Http.post
        { url = "https://fervent-colden-5f0cd2.netlify.app/.netlify/functions/transDim"
        , body = Http.jsonBody bodyValue
        , expect = Http.expectWhatever ReceiveEmailResponse
        }


emailBody : FormInput -> Json.Encode.Value
emailBody formData =
    Json.Encode.object
        [ ( "formData"
          , Json.Encode.object
                [ ( "name", Json.Encode.string formData.name.value )
                , ( "email", Json.Encode.string formData.email.value )
                , ( "job", Json.Encode.string formData.job.value )
                , ( "organisation", Json.Encode.string formData.org.value )
                , ( "ringBack", Json.Encode.bool formData.ringBack.value )
                , ( "moreInfo", Json.Encode.bool formData.moreInfo.value )
                , ( "message", Json.Encode.string formData.message.value )
                , ( "phone", Json.Encode.string formData.phone.value )
                , ( "postcode", Json.Encode.string formData.address.value )
                ]
          )
        ]


type Msg
    = UpdateName String
    | UpdateEmail String
    | UpdatePhone String
    | UpdateJob String
    | UpdateOrg String
    | UpdateAddress String
    | UpdateRingBack Bool
    | UpdateMoreInfo Bool
    | UpdateMessage String
    | ErrorName FormError
    | ErrorEmail FormError
    | ErrorMessage FormError
    | SetFormState FormState
    | ClickSend
    | SendEmail
    | ReceiveEmailResponse (Result Http.Error ())


run : Msg -> Cmd Msg
run m =
    Task.perform (always m) (Task.succeed ())


type alias RouteParams =
    {}


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( { userInput = blankForm, formState = Inputting }, Cmd.none )


update :
    PageUrl
    -> Maybe Browser.Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update pageUrl maybeNavigationKey sharedModel static msg ({ userInput } as model) =
    case msg of
        UpdateName newString ->
            let
                oldField =
                    userInput.name

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | name = newField } }, Cmd.none )

        UpdateEmail newString ->
            let
                oldField =
                    userInput.email

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | email = newField } }, Cmd.none )

        UpdatePhone newString ->
            let
                oldField =
                    userInput.phone

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | phone = newField } }, Cmd.none )

        UpdateJob newString ->
            let
                oldField =
                    userInput.job

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | job = newField } }, Cmd.none )

        UpdateOrg newString ->
            let
                oldField =
                    userInput.org

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | org = newField } }, Cmd.none )

        UpdateAddress newString ->
            let
                oldField =
                    userInput.address

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | address = newField } }, Cmd.none )

        UpdateRingBack newBool ->
            let
                oldField =
                    userInput.ringBack

                newField =
                    { oldField | value = newBool }
            in
            ( { model | userInput = { userInput | ringBack = newField } }, Cmd.none )

        UpdateMoreInfo newBool ->
            let
                oldField =
                    userInput.moreInfo

                newField =
                    { oldField | value = newBool }
            in
            ( { model | userInput = { userInput | moreInfo = newField } }, Cmd.none )

        UpdateMessage newString ->
            let
                oldField =
                    userInput.message

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | message = newField } }, Cmd.none )

        ErrorName errorType ->
            let
                oldField =
                    userInput.name

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | name = newField } }, Cmd.none )

        ErrorEmail errorType ->
            let
                oldField =
                    userInput.email

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | email = newField } }, Cmd.none )

        ErrorMessage errorType ->
            let
                oldField =
                    userInput.message

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | message = newField } }, Cmd.none )

        ClickSend ->
            ( model, Cmd.batch (List.map (\message -> run message) (validateForm model.userInput)) )

        SendEmail ->
            ( model, emailPostRequest (emailBody model.userInput) )

        SetFormState newState ->
            ( { model | formState = newState }, Cmd.none )

        ReceiveEmailResponse result ->
            case result of
                Ok _ ->
                    ( { userInput = blankForm, formState = Sent }, Cmd.none )

                Err httpError ->
                    ( { model | formState = SendingError }, Cmd.none )


subscriptions :
    Maybe PageUrl
    -> RouteParams
    -> Path
    -> Model
    -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


page : PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { init = init
            , update = update
            , subscriptions = subscriptions
            , view = view
            }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = JoinUsTitle
        , description = JoinUsMetaDescription
        , imageSrc = Nothing
        }


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel localModel static =
    { title = t (PageMetaTitle (t JoinUsTitle))
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t JoinUsTitle
            , bigText = { text = t JoinUsSubtitle, node = "p" }
            , smallText = Just [ t JoinUsDescription ]
            , innerContent = Just (viewForm localModel)
            , outerContent = Nothing

            -- , outerContent = Just (viewFormStateForTesting localModel.formState)
            }
        ]
    }


viewForm : Model -> Html Msg
viewForm state =
    form [ css [ formStyle ], onSubmit ClickSend ]
        [ label [ css [ formItemStyle ] ]
            [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputNameLabel) ]
            , input
                [ css
                    [ if state.userInput.name.error == Nothing then
                        textInputStyle

                      else
                        textInputErrorStyle
                    ]
                , value state.userInput.name.value
                , onInput UpdateName
                ]
                []
            ]
        , label [ css [ formItemStyle ] ]
            [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputEmailLabel) ]
            , input
                [ css
                    [ if state.userInput.email.error == Nothing then
                        textInputStyle

                      else
                        textInputErrorStyle
                    ]
                , value state.userInput.email.value
                , onInput UpdateEmail
                ]
                []
            ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputPhoneLabel) ], input [ css [ textInputStyle ], value state.userInput.phone.value, onInput UpdatePhone ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputJobLabel) ], input [ css [ textInputStyle ], value state.userInput.job.value, onInput UpdateJob ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputOrgLabel) ], input [ css [ textInputStyle ], value state.userInput.org.value, onInput UpdateOrg ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputAddressLabel) ], input [ css [ textInputStyle ], value state.userInput.address.value, onInput UpdateAddress ] [] ]
        , div [ css [ formCheckboxWrapperStyle ] ]
            [ p [ css [ formCheckboxTitleStyle ] ] [ text (t JoinUsFormCheckboxesLabel) ]
            , div [] (viewCheckbox "joinbox1" (t JoinUsFormCheckbox1) state.userInput.ringBack.value UpdateRingBack)
            , div [] (viewCheckbox "joinbox2" (t JoinUsFormCheckbox2) state.userInput.moreInfo.value UpdateMoreInfo)
            ]
        , label [ css [ formTextAreaItemStyle ] ]
            [ span [ css [ formTextAreaLabelStyle ] ] [ text (t JoinUsFormInputMessageLabel) ]
            , textarea
                [ placeholder (t JoinUsFormInputMessagePlaceholder)
                , css
                    [ if state.userInput.name.error == Nothing then
                        textAreaStyle

                      else
                        textAreaErrorStyle
                    ]
                , value state.userInput.message.value
                , onInput UpdateMessage
                ]
                []
            ]
        , div [ css [ buttonWrapperStyle ] ]
            [ button [ css [ formButtonStyle ], type_ "submit" ]
                [ text
                    (if state.formState == Sending then
                        "Sending..."

                     else
                        t JoinUsFormSubmitButton
                    )
                ]
            ]
        , if state.formState == ValidationError then
            p [ css [ formHelperStyle ] ] [ text "Make sure you have filled in the name, email and address fields." ]

          else
            text ""
        , if state.formState == SendingError then
            p [ css [ formHelperStyle ] ] [ text "Your message failed to send. Please try again." ]

          else
            text ""
        , if state.formState == Sent then
            p [ css [ formHelperStyle ] ] [ text "Your message has been sent! We will get back to you as soon as we can." ]

          else
            text ""
        ]


formStyle : Style
formStyle =
    batch
        [ margin2 (rem 2) (rem 0)
        , withMediaSmallDesktopUp [ maxWidth (px 900), margin2 (rem 2) auto ]
        , withMediaTabletLandscapeUp [ fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp
            [ displayFlex
            , flexWrap wrap
            , justifyContent spaceBetween
            ]
        ]


formItemStyle : Style
formItemStyle =
    batch
        [ displayFlex
        , flexDirection column
        , margin2 (rem 1.5) (rem 0)
        , withMediaTabletPortraitUp
            [ width (calc (pct 50) minus (rem 2))
            , margin (rem 0.75)
            ]
        ]


formTextAreaItemStyle : Style
formTextAreaItemStyle =
    batch
        [ formItemStyle
        , withMediaTabletPortraitUp [ important (width (pct 100)), flexDirection row ]
        ]


formLabelStyle : Style
formLabelStyle =
    batch
        [ display block
        , textAlign center
        , margin2 (rem 0.25) (rem 0)
        , textTransform uppercase
        , fontWeight (int 700)
        , letterSpacing (px 1.6)
        ]


formTextAreaLabelStyle : Style
formTextAreaLabelStyle =
    batch
        [ formLabelStyle
        , withMediaTabletPortraitUp
            [ marginRight (rem 2)
            , flexShrink (int 0)
            , marginTop (rem 0.5)
            ]
        ]


formCheckboxTitleStyle : Style
formCheckboxTitleStyle =
    batch
        [ formLabelStyle
        , withMediaTabletPortraitUp [ marginRight (rem 2) ]
        ]


formCheckboxWrapperStyle : Style
formCheckboxWrapperStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 100)
            , displayFlex
            , justifyContent center
            , alignItems center
            ]
        ]


textAreaStyle : Style
textAreaStyle =
    batch
        [ textInputStyle
        , boxSizing borderBox
        , height (px 140)
        , margin2 (rem 0.5) (rem 0)
        , padding2 (rem 1) (rem 1.5)
        , pseudoElement "placeholder" [ color white ]
        , width (pct 100)
        , withMediaTabletPortraitUp [ height (px 100) ]
        ]


textAreaErrorStyle : Style
textAreaErrorStyle =
    batch
        [ textInputErrorStyle
        , margin2 (rem 0.5) (rem 0)
        , padding2 (rem 1) (rem 1.5)
        , height (px 140)
        , width (pct 100)
        , boxSizing borderBox
        , withMediaTabletPortraitUp [ height (px 100) ]
        ]


buttonWrapperStyle : Style
buttonWrapperStyle =
    batch
        [ textAlign center
        , withMediaTabletPortraitUp [ width (pct 100) ]
        ]


formHelperStyle : Style
formHelperStyle =
    batch
        [ color pink
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , textAlign center
        , width (pct 100)
        , marginTop (rem 1)
        , lineHeight (em 1.3)
        , withMediaTabletPortraitUp [ fontSize (rem 1) ]
        ]


formButtonStyle : Style
formButtonStyle =
    batch
        [ pinkButtonOnDarkBackgroundStyle
        , padding2 (rem 0.25) (rem 4)
        , withMediaTabletPortraitUp [ marginTop (rem 1) ]
        ]
