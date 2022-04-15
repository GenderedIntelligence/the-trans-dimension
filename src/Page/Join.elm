module Page.Join exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, auto, backgroundColor, batch, block, border, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, calc, center, color, column, display, displayFlex, fitContent, flexDirection, flexShrink, flexWrap, fontSize, fontWeight, height, important, int, justifyContent, letterSpacing, margin, margin2, marginRight, marginTop, maxWidth, minus, none, padding, padding2, pct, property, px, rem, row, solid, spaceBetween, textAlign, textTransform, uppercase, width, wrap)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, button, div, form, h2, input, label, p, section, span, text, textarea)
import Html.Styled.Attributes exposing (css, placeholder, type_)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


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
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t JoinTitle
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t JoinTitle
            , bigText = { text = t JoinSubtitle, node = "p" }
            , smallText = Just [ t JoinDescription ]
            , innerContent = Just viewForm
            , outerContent = Nothing
            }
        ]
    }


viewForm : Html msg
viewForm =
    form [ css [ formStyle ] ]
        -- [fFf] Join form
        [ label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputNameLabel) ], input [ css [ formInputStyle ] ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputEmailLabel) ], input [ css [ formInputStyle ] ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputPhoneLabel) ], input [ css [ formInputStyle ] ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputJobLabel) ], input [ css [ formInputStyle ] ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputOrgLabel) ], input [ css [ formInputStyle ] ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinFormInputAddressLabel) ], input [ css [ formInputStyle ] ] [] ]
        , div [ css [ formCheckboxWrapperStyle ] ]
            [ p [ css [ formCheckboxTitleStyle ] ] [ text (t JoinFormCheckboxesLabel) ]
            , label [ css [ formCheckboxItemStyle ] ]
                [ span [ css [ formCheckboxLabelStyle ] ] [ text (t JoinFormCheckbox1) ]
                , input [ css [ checkboxStyle ], type_ "checkbox" ] []
                ]
            , label [ css [ formCheckboxItemStyle ] ]
                [ span [ css [ formCheckboxLabelStyle ] ] [ text (t Copy.Keys.JoinFormCheckbox2) ]
                , input [ css [ checkboxStyle ], type_ "checkbox" ] []
                ]
            ]
        , label [ css [ formTextAreaItemStyle ] ] [ span [ css [ formTextAreaLabelStyle ] ] [ text (t JoinFormInputMessageLabel) ], textarea [ placeholder (t JoinFormInputMessagePlaceholder), css [ textAreaStyle ] ] [] ]
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


formInputStyle : Style
formInputStyle =
    batch
        [ backgroundColor Theme.Global.darkBlue
        , borderColor Theme.Global.pink
        , borderWidth (px 2)
        , borderStyle solid
        , borderRadius (rem 0.3)
        , padding2 (rem 0.5) (rem 1)
        , color Theme.Global.white
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


formCheckboxItemStyle : Style
formCheckboxItemStyle =
    batch
        [ formItemStyle
        , flexDirection row
        , alignItems center
        , justifyContent center
        , margin (rem 0)
        , maxWidth fitContent
        ]


formCheckboxLabelStyle : Style
formCheckboxLabelStyle =
    batch
        [ color Theme.Global.pink
        , fontWeight (int 500)
        ]


checkboxStyle : Style
checkboxStyle =
    batch
        [ formInputStyle
        , property "appearance" "none"
        , padding (rem 1)
        , margin (rem 0.5)
        ]


textAreaStyle : Style
textAreaStyle =
    batch
        [ formInputStyle
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
