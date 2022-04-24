module Theme.PageTemplate exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, after, auto, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, borderBox, bottom, boxSizing, calc, center, color, display, fontSize, fontStyle, fontWeight, height, inline, int, italic, left, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, maxWidth, minus, noRepeat, none, outline, paddingBottom, paddingTop, pct, position, property, px, relative, rem, textAlign, top, url, vw, width, zIndex)
import Html.Styled as Html exposing (Html, div, h1, h2, h3, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, src)
import List exposing (append)
import Theme.Global exposing (contentContainerStyle, contentWrapperStyle, introTextLargeStyle, introTextSmallStyle, textBoxInvisibleStyle, textBoxPinkStyle, white, withMediaMediumDesktopUp, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)


type alias Msg =
    Never


type alias PageUsingTemplate msg =
    { title : String
    , headerType : Maybe String
    , bigText : BigText
    , smallText : Maybe (List String)
    , innerContent : Maybe (Html.Html msg)
    , outerContent : Maybe (Html.Html msg)
    }


type alias BigText =
    { node : String
    , text : String
    }


type HeaderType
    = PinkHeader
    | InvisibleHeader
    | AboutHeader


stringToHeaderType : Maybe String -> HeaderType
stringToHeaderType maybeTypeString =
    case maybeTypeString of
        Just "pink" ->
            PinkHeader

        Just "invisible" ->
            InvisibleHeader

        Just "about" ->
            AboutHeader

        Just _ ->
            PinkHeader

        Nothing ->
            PinkHeader


view : PageUsingTemplate msg -> Html.Html msg
view pageInfo =
    div [ css [ mainStyle ] ]
        [ viewHeader pageInfo
        , div [ css [ contentWrapperStyle ] ]
            [ case stringToHeaderType pageInfo.headerType of
                InvisibleHeader ->
                    viewIntroBlue pageInfo.bigText pageInfo.smallText

                _ ->
                    viewIntro pageInfo.bigText pageInfo.smallText
            , case pageInfo.innerContent of
                Just boxContents ->
                    div [ css [ contentContainerStyle ] ] [ boxContents ]

                Nothing ->
                    text ""
            ]
        , case pageInfo.outerContent of
            Just footerContent ->
                footerContent

            Nothing ->
                text ""
        ]


viewHeader : PageUsingTemplate msg -> Html msg
viewHeader pageInfo =
    section [ css [ headerSectionStyle ] ]
        [ h1 [ css [ headerLogoStyle ] ]
            [ img
                [ src "/images/logos/tdd_logo_with_strapline.svg"
                , alt (t SiteTitle)
                , css [ headerLogoImageStyle ]
                ]
                []
            ]
        , h2
            [ css
                [ pageHeadingStyle
                , case stringToHeaderType pageInfo.headerType of
                    AboutHeader ->
                        pageHeadingAboutStyle

                    _ ->
                        pageHeadingGenericStyle
                ]
            ]
            [ text pageInfo.title ]
        ]


viewIntro : BigText -> Maybe (List String) -> Html msg
viewIntro bigText smallText =
    section
        [ css
            (case smallText of
                Nothing ->
                    [ textBoxPinkStyle ]

                Just _ ->
                    [ withMediaTabletPortraitUp
                        [ paddingTop (rem 1.5) ]
                    , textBoxPinkStyle
                    ]
            )
        ]
        (append
            [ case bigText.node of
                "h3" ->
                    h3 [ css [ introTextH3Style, introTextLargeStyle ] ] [ text bigText.text ]

                _ ->
                    Html.node bigText.node [ css [ introTextLargeStyle ] ] [ text bigText.text ]
            ]
            (case smallText of
                Just textList ->
                    List.map (\smallParagraph -> p [ css [ introTextSmallStyle ] ] [ text smallParagraph ]) textList

                Nothing ->
                    []
            )
        )


viewIntroBlue : BigText -> Maybe (List String) -> Html msg
viewIntroBlue bigText smallText =
    section [ css [ textBoxInvisibleStyle ] ]
        (append
            [ Html.node bigText.node [ css [ introTextLargeStyle ] ] [ text bigText.text ]
            ]
            (case smallText of
                Just textList ->
                    List.map (\smallParagraph -> p [ css [ introTextSmallStyle ] ] [ text smallParagraph ]) textList

                Nothing ->
                    []
            )
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
        , paddingBottom (rem 0.5)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , zIndex (int -1)
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , withMediaMediumDesktopUp
                [ backgroundSize (px 1920)
                ]
            , withMediaSmallDesktopUp
                [ backgroundSize (px 1366)
                , margin2 (rem 0) (calc (vw -50) minus (px -575))
                ]
            , withMediaTabletLandscapeUp
                [ backgroundSize (px 1200)
                , margin2 (rem 0) (rem -1.5)
                ]
            , withMediaTabletPortraitUp
                [ backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                ]
            ]
        , withMediaTabletLandscapeUp
            [ fontSize (rem 3.1), paddingBottom (rem 1) ]
        , withMediaTabletPortraitUp
            [ fontSize (rem 2.5) ]
        ]


pageHeadingGenericStyle : Style
pageHeadingGenericStyle =
    batch
        [ before
            [ height (px 240)
            , backgroundImage (url "/images/illustrations/320px/generic_header.png")
            , top (px -130)
            , withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/generic_header.png")
                , height (px 846)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/generic_header.png")
                , height (px 486)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/generic_header.png")
                , height (px 499)
                , top (px -100)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/generic_header.png")
                , height (px 432)
                , top (px -75)
                ]
            ]
        , withMediaTabletLandscapeUp
            [ paddingTop (px 275) ]
        , withMediaTabletPortraitUp
            [ paddingTop (px 250) ]
        ]


pageHeadingAboutStyle : Style
pageHeadingAboutStyle =
    batch
        [ before
            [ height (px 240)
            , backgroundImage (url "/images/illustrations/320px/about_1_header.png")
            , top (px -130)
            , withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/about_1_header.png")
                , height (px 1150)
                , top (px -130)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/about_1_header.png")
                , height (px 486)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_1_header.png")
                , height (px 499)
                , top (px -100)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_1_header.png")
                , height (px 432)
                , top (px -75)
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ width (px 231)
                , height (px 434)
                , backgroundSize (px 231)
                , bottom (px -250)
                , left (px -100)
                ]
            , withMediaTabletLandscapeUp
                [ property "content" "\"\""
                , display block
                , width (px 162)
                , height (px 305)
                , backgroundSize (px 162)
                , backgroundPosition center
                , position absolute
                , zIndex (int 2)
                , backgroundRepeat noRepeat
                , backgroundImage (url "/images/characters/girl_with_afro.png")
                , bottom (px -90)
                ]
            ]
        , withMediaTabletLandscapeUp
            [ paddingTop (px 275) ]
        , withMediaTabletPortraitUp
            [ paddingTop (px 250) ]
        ]


mainStyle : Style
mainStyle =
    batch
        [ maxWidth (px 1150)
        , margin (rem 0.75)
        , boxSizing borderBox
        , position relative
        , marginBottom (px 150)
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
            , bottom (px -180)
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


introTextH3Style : Style
introTextH3Style =
    batch
        [ withMediaTabletLandscapeUp
            [ margin2 (rem 1) auto ]
        ]
