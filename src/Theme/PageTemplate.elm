module Theme.PageTemplate exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, after, auto, backgroundColor, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, bold, borderBox, borderColor, borderRadius, borderStyle, borderWidth, bottom, boxSizing, calc, center, color, display, displayFlex, flexWrap, fontSize, fontStyle, fontWeight, height, hover, inline, int, italic, justifyContent, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginLeft, marginTop, maxWidth, minus, noRepeat, none, outline, padding, padding2, paddingBottom, paddingLeft, paddingRight, paddingTop, pct, position, property, px, relative, rem, solid, spaceBetween, textAlign, textDecoration, top, url, vw, width, wrap, zIndex)
import Html.Styled as Html exposing (Html, div, h1, h2, img, main_, p, section, text)
import Html.Styled.Attributes exposing (alt, css, src)
import List exposing (append)
import Theme.Global as Theme exposing (darkBlue, pink, white, withMediaMediumDesktopUp, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)


type alias PageIntro =
    { title : String, bigText : String, smallText : List String }


view : PageIntro -> Html msg -> Html msg
view intro contents =
    main_ []
        [ viewHeader intro.title
        , div [ css [ contentWrapperStyle ] ]
            [ viewIntro intro.bigText intro.smallText
            , div [ css [ contentContainerStyle ] ] [ contents ]
            ]
        ]


viewHeader : String -> Html msg
viewHeader title =
    section [ css [ headerSectionStyle ] ]
        [ h1 [ css [ headerLogoStyle ] ]
            [ img
                [ src "/images/logos/tdd_logo_with_strapline.svg"
                , alt (t SiteTitle)
                , css [ headerLogoImageStyle ]
                ]
                []
            ]
        , h2 [ css [ pageHeadingStyle ] ] [ text title ]
        ]


viewIntro : String -> List String -> Html msg
viewIntro bigText smallTextList =
    section [ css [ introBoxStyle ] ]
        (append [ p [ css [ introTextLargeStyle ] ] [ text bigText ] ]
            (List.map (\smallText -> p [ css [ introTextSmallStyle ] ] [ text smallText ]) smallTextList)
        )


headerSectionStyle : Style
headerSectionStyle =
    batch
        [ position relative ]


headerLogoStyle : Style
headerLogoStyle =
    batch
        [ display none
        , withMediaTabletPortraitUp
            [ width (pct 100)
            , display block
            , textAlign center
            , position absolute
            , top (px 50)
            ]
        ]


headerLogoImageStyle : Style
headerLogoImageStyle =
    batch
        [ width (px 268)
        , display inline
        , withMediaTabletLandscapeUp [ width (px 305) ]
        ]


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
            , withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/generic_header.png")
                , backgroundSize (px 1920)
                , height (px 846)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/generic_header.png")
                , backgroundSize (px 1366)
                , height (px 486)
                ]
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
            [ fontSize (rem 2.5), paddingTop (px 250) ]
        ]


introBoxStyle : Style
introBoxStyle =
    batch
        [ backgroundColor pink
        , color darkBlue
        , padding (rem 1)
        , borderRadius (rem 0.3)
        , boxSizing borderBox
        , withMediaMediumDesktopUp
            [ paddingBottom (rem 2) ]
        , withMediaTabletPortraitUp
            [ paddingTop (rem 3), paddingLeft (rem 3.5), paddingRight (rem 3.5) ]
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


contentWrapperStyle : Style
contentWrapperStyle =
    batch
        [ maxWidth (px 1150)
        , boxSizing borderBox
        , margin (rem 0.75)
        , borderRadius (rem 0.3)
        , backgroundColor darkBlue
        , borderColor pink
        , borderStyle solid
        , borderWidth (px 1)
        , position relative
        , marginBottom (px 200)
        , after
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , height (px 230)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , zIndex (int -1)
            , backgroundRepeat noRepeat
            , backgroundImage (url "/images/illustrations/320px/generic_footer.png")
            , bottom (px -200)
            , margin2 (rem 0) (rem -0.75)
            , withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/generic_footer.png")
                , height (px 250)
                , bottom (px -220)
                , backgroundSize (px 1920)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/generic_footer.png")
                , height (px 200)
                , margin2 (rem 0) (calc (vw -50) minus (px -575))
                , bottom (px -180)
                , backgroundSize (px 1366)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/generic_footer.png")
                , height (px 280)
                , margin2 (rem 0) (rem -1.5)
                , bottom (px -200)
                , backgroundSize (px 1200)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/generic_footer.png")
                , backgroundSize (px 900)
                , height (px 200)
                , margin2 (rem 0) (rem -2)
                , bottom (px -165)
                ]
            ]
        , withMediaMediumDesktopUp
            [ margin4 (rem 1) auto (px 250) auto ]
        , withMediaSmallDesktopUp
            [ margin4 (rem 1) auto (px 180) auto ]
        , withMediaTabletLandscapeUp
            [ margin4 (rem 1) (rem 1.5) (px 180) (rem 1.5) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 1) (rem 2) (px 150) (rem 2) ]
        ]


contentContainerStyle : Style
contentContainerStyle =
    batch
        [ margin (rem 0.75)
        , withMediaMediumDesktopUp [ margin (rem 1.5) ]
        ]
