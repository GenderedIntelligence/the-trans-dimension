module Theme.Global exposing (backgroundColorTransition, black, blue, blueBackgroundStyle, borderTransition, buttonFloatingWrapperStyle, checkboxStyle, colorTransition, containerContent, containerPage, contentContainerStyle, contentWrapperStyle, darkBlue, darkBlueBackgroundStyle, darkBlueButtonStyle, darkBlueRgbColor, darkPurple, generateId, globalStyles, gridStyle, hrStyle, introTextLargeStyle, introTextSmallStyle, lightPink, linkStyle, mapImage, mapImageMulti, maxMobile, maxTabletPortrait, normalFirstParagraphStyle, oneColumn, pink, pinkBackgroundStyle, pinkButtonOnDarkBackgroundStyle, pinkButtonOnLightBackgroundStyle, pinkRgbColor, purple, smallFloatingTitleStyle, smallInlineTitleStyle, srOnly, textBoxInvisibleStyle, textBoxPinkStyle, textBoxStyle, textInputErrorStyle, textInputStyle, threeColumn, twoColumn, verticalSpacing, viewBackButton, viewCheckbox, viewSearchInput, viewSelect, white, whiteButtonStyle, withMediaLargeDesktopUp, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)

import Color
import Css exposing (Color, Style, absolute, active, after, alignItems, auto, backgroundColor, backgroundImage, backgroundRepeat, backgroundSize, batch, before, block, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderColor, borderRadius, borderStyle, borderWidth, bottom, boxSizing, calc, center, color, cursor, display, displayFlex, em, firstChild, fitContent, flexDirection, flexWrap, focus, fontFamilies, fontSize, fontStyle, fontWeight, height, hex, hidden, hover, inlineBlock, int, italic, justifyContent, left, letterSpacing, lineHeight, listStyleType, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginRight, marginTop, maxContent, maxWidth, minus, none, opacity, outline, overflow, padding, padding2, padding4, paddingBottom, paddingLeft, paddingRight, pct, pointer, position, property, pseudoClass, pseudoElement, px, relative, rem, repeat, right, row, sansSerif, solid, start, textAlign, textDecoration, textTransform, top, transparent, uppercase, url, width, wrap, zero)
import Css.Global exposing (adjacentSiblings, descendants, global, typeSelector)
import Css.Media as Media exposing (only, screen, withMedia)
import Css.Transitions exposing (Transition, linear, transition)
import Html.Styled exposing (Html, a, div, img, input, label, li, p, span, text, ul)
import Html.Styled.Attributes exposing (attribute, css, for, href, id, placeholder, src, tabindex, type_, value)
import Html.Styled.Events exposing (onCheck, onClick, onInput)



-- Brand colours


darkBlueRgbColor : Color.Color
darkBlueRgbColor =
    Color.rgb255 4 15 57


pinkRgbColor : Color.Color
pinkRgbColor =
    Color.rgb255 255 122 167


darkBlue : Color
darkBlue =
    hex "040F39"


pink : Color
pink =
    hex "FF7AA7"


lightPink : Color
lightPink =
    hex "FFBCD3"


purple : Color
purple =
    hex "814470"


darkPurple : Color
darkPurple =
    hex "683a65"


blue : Color
blue =
    hex "53C3FF"


white : Color
white =
    hex "FFFFFF"



-- Accent colours
-- Text and background colours


black : Color
black =
    hex "000000"



-- Breakpoints


maxMobile : Float
maxMobile =
    600


withMediaMobileOnly : List Style -> Style
withMediaMobileOnly =
    withMedia [ only screen [ Media.maxWidth (px (maxMobile - 1)) ] ]


withMediaTabletPortraitUp : List Style -> Style
withMediaTabletPortraitUp =
    withMedia [ only screen [ Media.minWidth (px maxMobile) ] ]


maxTabletPortrait : Float
maxTabletPortrait =
    900


withMediaTabletLandscapeUp : List Style -> Style
withMediaTabletLandscapeUp =
    withMedia [ only screen [ Media.minWidth (px maxTabletPortrait) ] ]


maxTabletLandscape : Float
maxTabletLandscape =
    1200


withMediaSmallDesktopUp : List Style -> Style
withMediaSmallDesktopUp =
    withMedia [ only screen [ Media.minWidth (px maxTabletLandscape) ] ]


maxSmallDesktop : Float
maxSmallDesktop =
    1500


withMediaMediumDesktopUp : List Style -> Style
withMediaMediumDesktopUp =
    withMedia [ only screen [ Media.minWidth (px maxSmallDesktop) ] ]


maxMediumDesktop : Float
maxMediumDesktop =
    2200


withMediaLargeDesktopUp : List Style -> Style
withMediaLargeDesktopUp =
    withMedia [ only screen [ Media.minWidth (px maxMediumDesktop) ] ]



-- Transitions


borderTransition : Transition
borderTransition =
    Css.Transitions.border3 500 0 linear


colorTransition : Transition
colorTransition =
    Css.Transitions.color3 500 0 linear


backgroundColorTransition : Transition
backgroundColorTransition =
    Css.Transitions.backgroundColor3 500 0 linear



-- Buttons (components)


viewBackButton : String -> String -> Html msg
viewBackButton link buttonText =
    p [ css [ backButtonStyle ] ]
        [ a [ href link, css [ darkBlueButtonStyle ] ] [ text buttonText ] ]



-- Buttons (styles)


buttonFloatingWrapperStyle : Style
buttonFloatingWrapperStyle =
    batch
        [ margin2 (rem 1) auto
        , display block
        , position absolute
        , bottom (rem -2)
        , textAlign center
        , width (pct 100)
        ]


whiteButtonStyle : Style
whiteButtonStyle =
    batch
        [ baseButtonStyle
        , backgroundColor white
        , color darkBlue
        , borderColor white
        , hover [ backgroundColor purple, color white ]
        , active [ backgroundColor darkBlue, color white ]
        , focus [ backgroundColor darkBlue, color white ]
        ]


darkBlueButtonStyle : Style
darkBlueButtonStyle =
    batch
        [ baseButtonStyle
        , backgroundColor darkBlue
        , color white
        , borderColor pink
        , hover [ backgroundColor purple, color white, borderColor white ]
        , active [ backgroundColor pink, color darkBlue, borderColor white ]
        , focus [ backgroundColor pink, color darkBlue, borderColor white ]
        ]


pinkButtonOnDarkBackgroundStyle : Style
pinkButtonOnDarkBackgroundStyle =
    batch
        [ baseButtonStyle
        , backgroundColor pink
        , color darkBlue
        , borderColor pink
        , hover [ backgroundColor lightPink, borderColor lightPink ]
        , active [ backgroundColor white, borderColor white ]
        , focus [ backgroundColor white, borderColor white ]
        ]


pinkButtonOnLightBackgroundStyle : Style
pinkButtonOnLightBackgroundStyle =
    batch
        [ baseButtonStyle
        , backgroundColor pink
        , color darkBlue
        , borderColor pink
        , hover [ backgroundColor purple, borderColor white, color white ]
        , active [ backgroundColor darkBlue, borderColor white, color white ]
        , focus [ backgroundColor darkBlue, borderColor white, color white ]
        ]


baseButtonStyle : Style
baseButtonStyle =
    batch
        [ textDecoration none
        , padding4 (rem 0.375) (rem 1.25) (rem 0.5) (rem 1.25)
        , borderRadius (rem 0.3)
        , fontWeight (int 600)
        , fontSize (rem 1.2)
        , display block
        , textAlign center
        , maxWidth maxContent
        , margin2 (rem 0) auto
        , borderWidth (rem 0.2)
        , borderStyle solid
        , transition [ backgroundColorTransition, borderTransition, colorTransition ]
        ]


backButtonStyle : Style
backButtonStyle =
    batch
        [ textAlign center
        , margin4 (rem 3) (rem 2) (rem 0) (rem 2)
        ]


pinkBackgroundStyle : Style
pinkBackgroundStyle =
    backgroundColor pink


blueBackgroundStyle : Style
blueBackgroundStyle =
    backgroundColor blue


darkBlueBackgroundStyle : Style
darkBlueBackgroundStyle =
    batch
        [ backgroundColor darkBlue
        , borderColor pink
        , borderStyle solid
        , borderWidth (px 1)
        ]



-- Titles


smallTitleStyle : Style
smallTitleStyle =
    batch
        [ textTransform uppercase
        , textAlign center
        , letterSpacing (px 1.9)
        , fontWeight (int 700)
        ]


smallFloatingTitleStyle : Style
smallFloatingTitleStyle =
    batch
        [ smallTitleStyle
        , position absolute
        , top (rem -3)
        , width (calc (pct 100) minus (rem 2))
        , left (rem 1)
        , fontSize (rem 1.2)
        , color white
        ]


smallInlineTitleStyle : Style
smallInlineTitleStyle =
    batch
        [ smallTitleStyle
        , fontSize (rem 1)
        , marginBlockStart (em 2)
        , marginBlockEnd (em 1.6)
        ]



-- Page Elements


textBoxStyle : Style
textBoxStyle =
    batch
        [ borderRadius (rem 0.3)
        , boxSizing borderBox
        , padding2 (rem 1) (rem 0.75)
        , withMediaMediumDesktopUp
            [ paddingBottom (rem 2) ]
        , withMediaTabletPortraitUp
            [ paddingLeft (rem 1.5), paddingRight (rem 1.5) ]
        ]


textBoxPinkStyle : Style
textBoxPinkStyle =
    batch
        [ textBoxStyle
        , backgroundColor pink
        , color darkBlue
        ]


textBoxInvisibleStyle : Style
textBoxInvisibleStyle =
    batch
        [ backgroundColor darkBlue
        , color pink
        , textBoxStyle
        , paddingBottom (rem 0)
        , descendants
            [ typeSelector "h3" [ batch [ color pink, withMediaTabletLandscapeUp [ margin4 (rem 2) auto (rem 0) auto ] ] ]
            , typeSelector "p" [ batch [ color pink, withMediaTabletLandscapeUp [ margin4 (rem 2) auto (rem 0) auto ] ] ]
            ]
        ]


contentWrapperStyle : Style
contentWrapperStyle =
    batch
        [ borderRadius (rem 0.3)
        , backgroundColor darkBlue
        , borderColor pink
        , borderStyle solid
        , borderWidth (px 1)
        ]


contentContainerStyle : Style
contentContainerStyle =
    batch
        [ margin (rem 0.75)
        , withMediaMediumDesktopUp [ margin (rem 1.5) ]
        , withMediaTabletPortraitUp [ margin2 (rem 0) (rem 2) ]
        ]


hrStyle : Style
hrStyle =
    batch
        [ borderColor pink
        , borderStyle solid
        , borderWidth (px 0.5)
        , margin2 (rem 2) (rem 0)
        ]



-- Text styles


introTextLargeStyle : Style
introTextLargeStyle =
    batch
        [ textAlign center
        , fontSize (rem 1.6)
        , lineHeight (rem 2)
        , fontStyle italic
        , fontWeight (int 500)
        , margin2 (rem 1) (rem 0.5)
        , withMediaTabletLandscapeUp
            [ fontSize (rem 2.5), lineHeight (rem 3.1), maxWidth (px 838), margin2 (rem 3) auto ]
        , withMediaTabletPortraitUp
            [ fontSize (rem 1.9), lineHeight (rem 2.1), margin2 (rem 1) (rem 1.5) ]
        ]


introTextSmallStyle : Style
introTextSmallStyle =
    batch
        [ textAlign center
        , margin2 (rem 1.5) (rem 0)
        , withMediaTabletLandscapeUp
            [ fontSize (rem 1.2), margin2 (rem 1.5) (rem 6.5) ]
        , withMediaTabletPortraitUp
            [ margin2 (rem 1.5) (rem 3.5) ]
        ]


linkStyle : Style
linkStyle =
    batch
        [ color white
        , borderBottomColor pink
        , borderBottomStyle solid
        , borderBottomWidth (px 1)
        , textDecoration none
        , hover [ color pink, borderBottomColor white ]
        , transition [ borderTransition, colorTransition ]
        ]


srOnly : Style
srOnly =
    batch
        [ position absolute
        , left (px -10000)
        , top auto
        , width (px 1)
        , height (px 1)
        , overflow hidden
        ]



--- For overriding the markdown style when we don't want it...


normalFirstParagraphStyle : Style
normalFirstParagraphStyle =
    batch
        [ descendants
            [ typeSelector "p"
                [ batch
                    [ firstChild
                        [ fontSize (rem 1)
                        , marginBlockEnd (em 1)
                        , lineHeight (em 1.5)
                        , withMediaSmallDesktopUp [ fontSize (rem 1.2) ]
                        , withMediaTabletPortraitUp [ marginBlockStart (em 0) ]
                        ]
                    ]
                ]
            ]
        ]



-- Form field components


viewSelect : String -> List { label : String, value : String } -> String -> (String -> msg) -> Bool -> msg -> Html msg
viewSelect fieldName optionList fieldValue update toggleValue toggleUpdate =
    label []
        [ span [ css [ searchLabelStyle ] ] [ text fieldName ]
        , div [ css [ fakeSelectStyle ], tabindex 0, id "select", onClick toggleUpdate ]
            [ div [ css [ selectStyle ] ]
                (if fieldValue == "" then
                    [ text "Show all" ]

                 else
                    List.map (\option -> text option.label) (List.filter (\str -> str.value == fieldValue) optionList)
                )
            , if toggleValue == True then
                ul
                    [ css [ selectOptionListStyle ], attribute "role" "listbox", tabindex 0 ]
                    (List.map
                        (\selectOption ->
                            li
                                [ css [ selectOptionStyle ]
                                , attribute "aria-selected"
                                    (if selectOption.value == fieldValue then
                                        "true"

                                     else
                                        "false"
                                    )
                                , onClick (update selectOption.value)
                                , attribute "role" "option"
                                ]
                                [ text selectOption.label ]
                        )
                        optionList
                    )

              else
                text ""
            ]
        ]


viewSearchInput : String -> String -> (String -> msg) -> Html msg
viewSearchInput labelText inputValue update =
    label [ css [ searchStyle ] ]
        [ span [ css [ searchLabelStyle ] ] [ text labelText ]
        , input [ css [ searchInputStyle ], type_ "search", value inputValue, onInput update, placeholder "Search" ] []
        , if inputValue == "" then
            text ""

          else
            img [ src "/images/icons/crossclose.svg", css [ searchInputCancelStyle ], onClick (update "") ] []
        ]


viewCheckbox : String -> String -> Bool -> (Bool -> msg) -> List (Html msg)
viewCheckbox boxId labelText checkedValue update =
    [ label
        [ css
            [ if checkedValue == True then
                checkboxLabelCheckedStyle

              else
                checkboxLabelStyle
            ]
        , for boxId
        ]
        [ text labelText ]
    , input [ css [ checkboxStyle ], type_ "checkbox", id boxId, Html.Styled.Attributes.checked checkedValue, onCheck update ] []
    ]



-- Form field styles


textInputStyle : Style
textInputStyle =
    batch
        [ backgroundColor darkBlue
        , borderColor pink
        , borderWidth (px 2)
        , borderStyle solid
        , borderRadius (rem 0.3)
        , padding2 (rem 0.5) (rem 1)
        , color white
        , outline none
        , focus [ borderColor white ]
        ]


textInputErrorStyle : Style
textInputErrorStyle =
    batch
        [ textInputStyle
        , backgroundColor pink
        , color darkBlue
        , borderColor white
        ]


checkboxLabelStyle : Style
checkboxLabelStyle =
    batch
        [ color pink
        , fontWeight (int 500)
        , displayFlex
        , flexDirection row
        , alignItems center
        , justifyContent center
        , margin2 (rem 0) auto
        , position relative
        , cursor pointer
        , maxWidth fitContent
        , withMediaTabletPortraitUp [ maxWidth (pct 100) ]
        , after
            [ property "content" "\"\""
            , textInputStyle
            , padding (rem 0)
            , width (em 2)
            , height (em 2)
            , backgroundColor transparent
            , property "appearance" "none"
            , margin (rem 0.5)
            , display block
            ]
        ]


checkboxLabelCheckedStyle : Style
checkboxLabelCheckedStyle =
    batch
        [ checkboxLabelStyle
        , before
            [ display block
            , property "content" "\"\""
            , width (em 1.25)
            , height (em 1.25)
            , margin (em 1)
            , position absolute
            , top (px 0)
            , right (px 0)
            , backgroundColor pink
            , borderRadius (em 1)
            ]
        ]


checkboxStyle : Style
checkboxStyle =
    batch
        [ display none
        ]


searchStyle : Style
searchStyle =
    batch
        [ position relative
        , margin2 (rem 1) auto
        , display block
        , maxWidth fitContent
        ]


searchLabelStyle : Style
searchLabelStyle =
    batch
        [ color white
        , fontWeight (int 600)
        , marginRight (rem 1)
        , fontSize (rem 1.2)
        , textTransform uppercase
        , letterSpacing (px 1.9)
        ]


searchInputStyle : Style
searchInputStyle =
    batch
        [ backgroundColor darkPurple
        , borderColor pink
        , borderWidth (px 2)
        , borderStyle solid
        , borderRadius (rem 0.3)
        , padding4 (rem 0.5) (rem 2.5) (rem 0.5) (rem 1)
        , fontSize (rem 1.2)
        , color white
        , fontWeight (int 600)
        , outline none
        , pseudoElement "placeholder" [ color pink, opacity (int 1), fontWeight (int 600) ]
        , pseudoClass "placeholder-shown"
            [ borderColor darkPurple
            ]
        , pseudoElement "-webkit-search-cancel-button" [ display none ]
        , focus [ borderColor white ]
        ]


searchInputCancelStyle : Style
searchInputCancelStyle =
    batch
        [ position absolute
        , display block
        , right (rem 0.5)
        , top (rem 0.825)
        , bottom (rem 0.825)
        , hover [ cursor pointer ]
        ]


fakeSelectStyle : Style
fakeSelectStyle =
    batch
        [ position relative
        , display inlineBlock
        ]


selectStyle : Style
selectStyle =
    batch
        [ property "appearance" "none"
        , backgroundColor darkBlue
        , borderColor pink
        , fontSize (rem 1.2)
        , fontWeight (int 600)
        , borderWidth (px 2)
        , borderStyle solid
        , borderRadius (rem 0.3)
        , padding2 (rem 0.5) (rem 1)
        , color pink
        , outline none
        , width (px 200)
        , pseudoElement "-ms-expand" [ display none ]
        ]


selectOptionListStyle : Style
selectOptionListStyle =
    batch
        [ maxWidth fitContent
        , backgroundColor pink
        , borderRadius (rem 0.3)
        , borderColor pink
        , borderStyle solid
        , borderWidth (px 2)
        , padding2 (rem 1) (rem 0)
        , listStyleType none
        , position absolute
        ]


selectOptionStyle : Style
selectOptionStyle =
    batch
        [ fontSize (rem 1.2)
        , fontWeight (int 500)
        , color darkBlue
        , borderRadius (rem 0.3)
        , padding2 (rem 0.5) (rem 1)
        , hover [ backgroundColor white ]
        ]



-- Global


{-| Injects a <style> tag into the body, and can target element or
class selectors anywhere, including outside the Elm app.
-}
globalStyles : Html msg
globalStyles =
    global
        [ typeSelector "body"
            [ backgroundColor darkBlue
            , color white
            , fontFamilies [ "covik-sans", sansSerif.value ]
            , fontWeight (int 400)
            , backgroundImage (url "/images/backgrounds/starfield-small-800.png")
            , backgroundRepeat repeat
            , backgroundSize (px 800)
            , withMediaMediumDesktopUp [ backgroundImage (url "/images/backgrounds/starfield-largest-1920.png"), backgroundSize (px 1920) ]
            , withMediaTabletLandscapeUp [ backgroundImage (url "/images/backgrounds/starfield-medium-1080.png"), backgroundSize (px 1080) ]
            ]
        , typeSelector "h1"
            [ color darkBlue
            ]
        , typeSelector "h2"
            [ color darkBlue
            ]
        , typeSelector "h3"
            [ color darkBlue
            ]
        , typeSelector "h4"
            [ color darkBlue
            ]
        , typeSelector "b"
            [ fontWeight (int 700)
            ]
        , typeSelector "p"
            [ adjacentSiblings
                [ typeSelector "p"
                    [ marginTop (rem 1)
                    ]
                ]
            ]
        , typeSelector "blockquote"
            [ adjacentSiblings
                [ typeSelector "blockquote"
                    [ marginTop (rem 1)
                    ]
                ]
            ]
        ]


containerPage : String -> List (Html msg) -> Html msg
containerPage pageTitle content =
    div
        [ id ("page-" ++ generateId pageTitle)
        , css [ margin2 zero auto, width (pct 100), overflow hidden ]
        ]
        content


containerContent : List (Html msg) -> Html msg
containerContent children =
    div [ css [ margin2 zero auto, Css.maxWidth (px 800), width (pct 100) ] ] children


gridStyle : Style
gridStyle =
    batch
        [ displayFlex
        , flexWrap wrap
        , alignItems start
        ]


{-| A flex row item width for a single column layout
oneColumn : Css.CalculatedLength (not exposed by <https://github.com/rtfeldman/elm-css/pull/519>)
-}
oneColumn =
    calc (pct 100) minus (rem 2)


{-| A flex row item width for a double column layout
twoColumn : Css.CalculatedLength
-}
twoColumn =
    calc (pct 50) minus (rem 2)


{-| A flex row item width for a triple column layout
threeColumn : Css.CalculatedLength
-}
threeColumn =
    calc (pct 33.33) minus (rem 2)


{-| A div with known vertical margin
-}
verticalSpacing : Float -> Html msg
verticalSpacing num =
    div [ css [ margin2 (rem num) zero ] ] []



-- Helpers


generateId : String -> String
generateId input =
    String.trim (String.replace " " "-" (String.toLower input))



-- Map


mapImageMulti : List { latitude : String, longitude : String } -> Html msg
mapImageMulti markerList =
    img [ src ("https://api.mapbox.com/styles/v1/studiosquid/cl082tq5a001o14mgaatx9fze/static/" ++ String.join "," (List.map (\marker -> "pin-l+ffffff(" ++ marker.longitude ++ "," ++ marker.latitude ++ ")") markerList) ++ "/auto/1140x400@2x?access_token=pk.eyJ1Ijoic3R1ZGlvc3F1aWQiLCJhIjoiY2o5bzZmNzhvMWI2dTJ3bnQ1aHFnd3loYSJ9.NC3T07dEr_Aw7wo1O8aF-g"), css [ mapStyle ] ] []


mapImage : { latitude : String, longitude : String } -> Html msg
mapImage geo =
    img [ src ("https://api.mapbox.com/styles/v1/studiosquid/cl082tq5a001o14mgaatx9fze/static/pin-l+ffffff(" ++ geo.longitude ++ "," ++ geo.latitude ++ ")/" ++ geo.longitude ++ "," ++ geo.latitude ++ ",15,0/1140x400@2x?access_token=pk.eyJ1Ijoic3R1ZGlvc3F1aWQiLCJhIjoiY2o5bzZmNzhvMWI2dTJ3bnQ1aHFnd3loYSJ9.NC3T07dEr_Aw7wo1O8aF-g"), css [ mapStyle ] ] []


mapStyle : Style
mapStyle =
    batch
        [ height (px 318)
        , width (pct 100)
        , property "object-fit" "cover"
        , withMediaTabletLandscapeUp [ height (px 400) ]
        , borderRadius (rem 0.3)
        ]
