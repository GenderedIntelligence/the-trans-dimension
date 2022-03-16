module Theme.Global exposing (black, blue, containerContent, containerPage, darkBlue, darkPurple, generateId, globalStyles, gridStyle, lightPink, maxMobile, oneColumn, pageHeadingStyle, pink, purple, threeColumn, twoColumn, verticalSpacing, white, withMediaLargeDesktopUp, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp, introBoxStyle, introTextLargeStyle, introTextSmallStyle)

import Css exposing (Color, Style, absolute, alignItems, auto, backgroundColor, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, bottom, calc, center, color, display, displayFlex, flexWrap, fontFamilies, fontSize, fontStyle, fontWeight, height, hex, int, italic, margin2, marginBlockEnd, marginBlockStart, marginTop, maxWidth, minus, noRepeat, none, outline, padding2, pct, position, property, px, relative, rem, repeat, sansSerif, start, textAlign, top, url, vw, width, wrap, zIndex, zero)
import Css.Global exposing (adjacentSiblings, global, typeSelector)
import Css.Media as Media exposing (maxWidth, minWidth, only, screen, withMedia)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css, id)
import Css exposing (paddingTop)
import Css exposing (padding)
import Css exposing (margin)
import Css exposing (borderRadius)
import Css exposing (lineHeight)
import Css exposing (paddingLeft)
import Css exposing (paddingRight)



-- Brand colours


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
            [ backgroundColor darkBlue
            , color white
            , fontFamilies [ "covik-sans", sansSerif.value ]
            , fontWeight (int 400)
            , backgroundImage (url "/images/backgrounds/starfield-small-800.png")
            , backgroundRepeat repeat
            , backgroundSize (px 800)
            , withMediaTabletLandscapeUp [ backgroundImage (url "/images/backgrounds/starfield-medium-1080.png"), backgroundSize (px 1080) ]
            , withMediaMediumDesktopUp [ backgroundImage (url "/images/backgrounds/starfield-largest-1920.png"), backgroundSize (px 1920) ]
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
        , css [ margin2 zero auto, width (pct 100) ]
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
        [ fontSize (rem 2.1)
        , outline none
        , color white
        , fontStyle italic
        , fontWeight (int 500)
        , textAlign center
        , marginBlockStart (rem 0)
        , marginBlockEnd (rem 0)
        , position relative
        , paddingTop (rem 2)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , height (px 240)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , zIndex (int -1)
            , backgroundRepeat noRepeat
            , backgroundImage (url "/images/illustrations/320px/generic_header.png")
            , top (px -130)
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/generic_header.png")
                , backgroundSize (px 1200)
                , height (px 499)
                , top (px -100) 
                ]
            , withMediaTabletPortraitUp 
                [ backgroundImage (url "/images/illustrations/768px/generic_header.png")
                , backgroundSize (px 900)
                , height (px 432)
                , top (px -75)
                ]
            ]
        , withMediaTabletLandscapeUp
            [ fontSize (rem 3.1), paddingTop (px 275) ]
        , withMediaTabletPortraitUp
            [ fontSize (rem 2.5), paddingTop (px 250)  ]
        ]

introBoxStyle : Style
introBoxStyle =
    batch
        [ backgroundColor pink
        , color darkBlue
        , padding (rem 1)
        , margin (rem 0.75)
        , borderRadius (rem 0.3)
        , withMediaTabletLandscapeUp
            [ margin2 (rem 1) (rem 1.5)]
        , withMediaTabletPortraitUp
            [ margin2 (rem 1) (rem 2), paddingTop (rem 3), paddingLeft (rem 3.5), paddingRight (rem 3.5) ]
        ]

introTextLargeStyle : Style
introTextLargeStyle =
    batch
        [ textAlign center
        , fontSize (rem 1.6)
        , lineHeight (rem 2)
        , fontStyle italic
        , fontWeight (int 400)
        , margin (rem 1)
        , withMediaTabletLandscapeUp
            [ fontSize (rem 2.5), lineHeight (rem 3.1) ]
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

-- Helpers


generateId : String -> String
generateId input =
    String.trim (String.replace " " "-" (String.toLower input))
