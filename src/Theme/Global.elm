module Theme.Global exposing (black, blue, containerContent, containerPage, darkBlue, generateId, globalStyles, gridStyle, maxMobile, oneColumn, pageHeadingStyle, pink, threeColumn, twoColumn, verticalSpacing, white, withMediaLargeDesktopUp, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)

import Css exposing (Color, Style, alignItems, auto, backgroundColor, batch, calc, center, color, displayFlex, flexWrap, fontFamilies, fontSize, fontWeight, hex, int, margin2, marginTop, maxWidth, minus, none, outline, padding2, pct, px, rem, sansSerif, start, textAlign, width, wrap, zero)
import Css.Global exposing (adjacentSiblings, global, typeSelector)
import Css.Media as Media exposing (maxWidth, minWidth, only, screen, withMedia)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css, id)



-- Brand colours


darkBlue : Color
darkBlue =
    hex "040F39"


pink : Color
pink =
    hex "FF7AA7"


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
    500


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


{-| Injects a <style> tag into the body, and can target element or
class selectors anywhere, including outside the Elm app.
-}
globalStyles : Html msg
globalStyles =
    global
        [ typeSelector "body"
            [ backgroundColor white
            , color darkBlue
            , fontFamilies [ "covik-sans", sansSerif.value ]
            , fontWeight (int 400)
            ]
        , typeSelector "h1"
            [ color blue
            ]
        , typeSelector "h2"
            [ color blue
            ]
        , typeSelector "h3"
            [ color blue
            ]
        , typeSelector "h4"
            [ color blue
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
        , css [ margin2 zero auto, Css.maxWidth (px 1200), width (pct 100) ]
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


{-| For a top header, likely an h1
-}
pageHeadingStyle : Style
pageHeadingStyle =
    batch
        [ fontSize (rem 1.8)
        , outline none
        , padding2 (rem 2) zero
        , textAlign center
        , withMediaTabletPortraitUp
            [ fontSize (rem 2.5) ]
        , withMediaTabletLandscapeUp
            [ fontSize (rem 2.5) ]
        ]



-- Helpers


generateId : String -> String
generateId input =
    String.trim (String.replace " " "-" (String.toLower input))
