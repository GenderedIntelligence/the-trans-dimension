module Page.Join exposing (Data, Model, Msg, blankForm, page, view)

import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, auto, backgroundColor, batch, block, border, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, calc, center, color, column, display, displayFlex, fitContent, flexDirection, flexShrink, flexWrap, fontSize, fontWeight, height, important, int, justifyContent, letterSpacing, local, margin, margin2, marginRight, marginTop, maxWidth, minus, none, padding, padding2, pct, property, px, rem, row, solid, spaceBetween, textAlign, textTransform, uppercase, width, wrap)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, a, button, div, form, h2, input, label, p, section, span, text, textarea)
import Html.Styled.Attributes exposing (css, placeholder, type_, value)
import Html.Styled.Events exposing (onInput)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import Theme.Global exposing (textInputStyle, viewCheckbox, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
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


type alias Checkbox =
    { value : Bool
    , required : FormRequired
    }


type alias Model =
    { userInput : FormInput
    }


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


type alias RouteParams =
    {}


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( { userInput = blankForm }, Cmd.none )


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
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = t SiteTitle
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t JoinMetaDescription
        , locale = Nothing
        , title = t JoinTitle -- metadata.title
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel localModel static =
    { title = t JoinTitle
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t JoinTitle
            , bigText = { text = t JoinSubtitle, node = "p" }
            , smallText = Just [ t JoinDescription ]
            , innerContent = Just (viewForm localModel.userInput)
            , outerContent = Nothing
            }
        ]
    }


viewForm : FormInput -> Html Msg
viewForm formState =
    form [ css [ formStyle ] ]
        -- [fFf] Join form
        [ label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputNameLabel) ], input [ css [ textInputStyle ], value formState.name.value, onInput UpdateName ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputEmailLabel) ], input [ css [ textInputStyle ], value formState.email.value, onInput UpdateEmail ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputPhoneLabel) ], input [ css [ textInputStyle ], value formState.phone.value, onInput UpdatePhone ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputJobLabel) ], input [ css [ textInputStyle ], value formState.job.value, onInput UpdateJob ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputOrgLabel) ], input [ css [ textInputStyle ], value formState.org.value, onInput UpdateOrg ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputAddressLabel) ], input [ css [ textInputStyle ], value formState.address.value, onInput UpdateAddress ] [] ]
        , div [ css [ formCheckboxWrapperStyle ] ]
            [ p [ css [ formCheckboxTitleStyle ] ] [ text (t JoinFormCheckboxesLabel) ]
            , div [] (viewCheckbox "joinbox1" (t JoinFormCheckbox1) formState.ringBack.value UpdateRingBack)
            , div [] (viewCheckbox "joinbox2" (t JoinFormCheckbox2) formState.moreInfo.value UpdateMoreInfo)
            ]
        , label [ css [ formTextAreaItemStyle ] ] [ span [ css [ formTextAreaLabelStyle ] ] [ text (t JoinFormInputMessageLabel) ], textarea [ placeholder (t JoinFormInputMessagePlaceholder), css [ textAreaStyle ], value formState.message.value, onInput UpdateMessage ] [] ]
        , div [ css [ buttonWrapperStyle ] ] [ button [ css [ buttonStyle ], type_ "submit" ] [ text (t JoinFormSubmitButton) ] ]
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
        , withMediaTabletPortraitUp [ important (width (pct 100)) ]
        , flexDirection row
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
        , margin2 (rem 0.5) (rem 0)
        , padding2 (rem 1) (rem 1.5)
        , height (px 100)
        , width (pct 100)
        , boxSizing borderBox
        ]


buttonWrapperStyle : Style
buttonWrapperStyle =
    batch
        [ textAlign center
        , withMediaTabletPortraitUp [ width (pct 100) ]
        ]


buttonStyle : Style
buttonStyle =
    batch
        [ backgroundColor Theme.Global.pink
        , color Theme.Global.darkBlue
        , borderRadius (rem 0.3)
        , borderStyle none
        , padding2 (rem 0.25) (rem 4)
        , fontSize (rem 1.2)
        , fontWeight (int 500)
        ]
