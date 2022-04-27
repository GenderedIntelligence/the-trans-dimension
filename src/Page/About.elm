module Page.About exposing (Data, Model, Msg, page, view)

import Css exposing (Style, absolute, after, alignItems, auto, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, bottom, calc, center, column, display, displayFlex, flexDirection, flexShrink, height, important, int, justifyContent, left, margin, margin2, margin4, marginBottom, marginLeft, marginRight, marginTop, maxWidth, minus, noRepeat, nthChild, padding, paddingBottom, paddingLeft, paddingRight, paddingTop, pct, position, property, px, relative, rem, right, spaceAround, top, url, vw, width, zIndex)
import Css.Global exposing (descendants, typeSelector)
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (a, div, h3, h4, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, href, src)
import List exposing (concat)
import OptimizedDecoder as Decode
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (buttonFloatingWrapperStyle, contentContainerStyle, contentWrapperStyle, introTextLargeStyle, normalFirstParagraphStyle, smallFloatingTitleStyle, textBoxPinkStyle, whiteButtonStyle, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Theme.TransMarkdown as TransMarkdown
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


type alias Data =
    { main : SectionWithTextHeader
    , accessibility : SectionWithTextHeader
    , makers : List Maker
    , placecal : SectionWithImageHeader
    }


type alias SectionWithTextHeader =
    { title : String
    , subtitle : String
    , body : List (Html.Html Msg)
    }


type alias SectionWithImageHeader =
    { title : String
    , subtitleimgalt : String
    , subtitleimg : String
    , body : List (Html.Html Msg)
    }


type alias Maker =
    { name : String, url : String, logo : String, body : List (Html.Html Msg) }


data : DataSource Data
data =
    DataSource.map4
        (\main accessibility makers placecal ->
            { main = main
            , accessibility = accessibility
            , makers = makers
            , placecal = placecal
            }
        )
        (DataSource.File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map3
                    (\title subtitle renderedMarkdown ->
                        { title = title
                        , subtitle = subtitle
                        , body = renderedMarkdown
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "subtitle" Decode.string)
                    (markdownString
                        |> TransMarkdown.markdownToView
                        |> Decode.fromResult
                    )
            )
            "content/about/main.md"
        )
        (DataSource.File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map3
                    (\title subtitle renderedMarkdown ->
                        { title = title
                        , subtitle = subtitle
                        , body = renderedMarkdown
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "subtitle" Decode.string)
                    (markdownString
                        |> TransMarkdown.markdownToView
                        |> Decode.fromResult
                    )
            )
            "content/about/accessibility.md"
        )
        (DataSource.map2
            (\gi gfsc ->
                [ gi, gfsc ]
            )
            (DataSource.File.bodyWithFrontmatter
                (\markdownString ->
                    Decode.map4
                        (\name logo url renderedMarkdown ->
                            { name = name
                            , logo = logo
                            , url = url
                            , body = renderedMarkdown
                            }
                        )
                        (Decode.field "name" Decode.string)
                        (Decode.field "logo" Decode.string)
                        (Decode.field "url" Decode.string)
                        (markdownString
                            |> TransMarkdown.markdownToView
                            |> Decode.fromResult
                        )
                )
                "content/about/makers/gfsc.md"
            )
            (DataSource.File.bodyWithFrontmatter
                (\markdownString ->
                    Decode.map4
                        (\name logo url renderedMarkdown ->
                            { name = name
                            , logo = logo
                            , url = url
                            , body = renderedMarkdown
                            }
                        )
                        (Decode.field "name" Decode.string)
                        (Decode.field "logo" Decode.string)
                        (Decode.field "url" Decode.string)
                        (markdownString
                            |> TransMarkdown.markdownToView
                            |> Decode.fromResult
                        )
                )
                "content/about/makers/gi.md"
            )
        )
        (DataSource.File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map4
                    (\title subtitleimg subtitleimgalt renderedMarkdown ->
                        { title = title
                        , subtitleimg = subtitleimg
                        , subtitleimgalt = subtitleimgalt
                        , body = renderedMarkdown
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "subtitleimg" Decode.string)
                    (Decode.field "subtitleimgalt" Decode.string)
                    (markdownString
                        |> TransMarkdown.markdownToView
                        |> Decode.fromResult
                    )
            )
            "content/about/placecal.md"
        )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.main.title
    , body =
        [ PageTemplate.view
            { headerType = Just "about"
            , title = static.data.main.title
            , bigText = { text = static.data.main.subtitle, node = "p" }
            , smallText = Nothing
            , innerContent = Just (viewAboutIntro static)
            , outerContent = Just (viewAboutSections static)
            }
        ]
    }


viewAboutIntro : StaticPayload Data RouteParams -> Html.Html Msg
viewAboutIntro static =
    section [ css [ aboutIntroTextStyle ] ] static.data.main.body


viewAboutSections : StaticPayload Data RouteParams -> Html.Html Msg
viewAboutSections static =
    div []
        [ viewAboutAccessibility static
        , viewMakers static
        , viewAboutPlaceCal static
        ]


viewAboutAccessibility : StaticPayload Data RouteParams -> Html.Html Msg
viewAboutAccessibility static =
    section [ css [ contentWrapperStyle, accessibilityStyle ] ]
        [ h3 [ css [ smallFloatingTitleStyle, withMediaMobileOnly [ top (rem -4.5) ] ] ] [ text static.data.accessibility.title ]
        , div [ css [ textBoxPinkStyle, accessibilityCharactersStyle ] ] [ p [ css [ introTextLargeStyle ] ] [ text static.data.accessibility.subtitle ] ]
        , div [ css [ contentContainerStyle, aboutAccessibilityTextStyle ] ] static.data.accessibility.body
        ]


viewMakers : StaticPayload Data RouteParams -> Html.Html Msg
viewMakers static =
    section [ css [ makersStyle ] ]
        (concat
            [ [ h3 [ css [ smallFloatingTitleStyle ] ] [ text "Meet the Makers" ] ]
            , List.map (\maker -> viewMaker maker) static.data.makers
            ]
        )


viewMaker : Maker -> Html.Html Msg
viewMaker maker =
    div [ css [ makerStyle, textBoxPinkStyle ] ]
        [ h4 [ css [ makerHeaderStyle ] ] [ img [ src maker.logo, alt maker.name, css [ makerLogoStyle ] ] [] ]
        , div [ css [ normalFirstParagraphStyle ] ] maker.body
        , p [ css [ buttonFloatingWrapperStyle ] ] [ a [ href maker.url, css [ whiteButtonStyle ] ] [ text "Find out more" ] ]
        ]


viewAboutPlaceCal : StaticPayload Data RouteParams -> Html.Html Msg
viewAboutPlaceCal static =
    section [ css [ contentWrapperStyle, placeCalStyle ] ]
        [ h3 [ css [ smallFloatingTitleStyle ] ] [ text static.data.placecal.title ]
        , div [ css [ textBoxPinkStyle ] ]
            [ img
                [ src static.data.placecal.subtitleimg
                , alt static.data.placecal.subtitleimgalt
                , css [ placeCalLogoStyle ]
                ]
                []
            ]
        , div [ css [ columnsStyle, contentContainerStyle, normalFirstParagraphStyle ] ] static.data.placecal.body
        ]


columnsStyle : Style
columnsStyle =
    batch
        [ withMediaSmallDesktopUp
            [ property "column-gap" "2rem"
            , maxWidth (px 848)
            , important (marginLeft auto)
            , important (marginRight auto)
            ]
        , withMediaTabletPortraitUp
            [ property "columns" "2"
            , important (marginTop (rem 3))
            , important (marginBottom (rem 3))
            ]
        ]


aboutTextStyle : Style
aboutTextStyle =
    batch
        [ normalFirstParagraphStyle
        , marginTop (rem 2)
        , marginBottom (rem 2)
        , descendants
            [ typeSelector "p"
                [ batch
                    [ withMediaMobileOnly
                        [ nthChild "3"
                            [ paddingTop (px 200)
                            , position relative
                            , before
                                [ property "content" "\"\""
                                , display block
                                , width (vw 100)
                                , backgroundSize (px 420)
                                , backgroundPosition center
                                , position absolute
                                , backgroundRepeat noRepeat
                                , margin2 (rem 0) (rem -1.5)
                                , height (px 230)
                                , top (px -30)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , columnsStyle
        ]


aboutIntroTextStyle : Style
aboutIntroTextStyle =
    batch
        [ aboutTextStyle
        , position relative
        , descendants
            [ typeSelector "p"
                [ batch
                    [ withMediaMobileOnly
                        [ nthChild "3"
                            [ before
                                [ backgroundImage (url "/images/illustrations/320px/about_2.png")
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ property "content" "\"\""
                , display block
                , width (px 298)
                , backgroundSize (px 298)
                , backgroundPosition center
                , position absolute
                , backgroundRepeat noRepeat
                , height (px 541)
                , bottom (px -160)
                , right (px -350)
                , backgroundImage (url "/images/characters/flag_holder.png")
                ]
            ]
        ]


accessibilityStyle : Style
accessibilityStyle =
    batch
        [ position relative
        , marginTop (px 370)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , height (px 290)
            , top (px -355)
            , backgroundImage (url "/images/illustrations/320px/about_3.png")
            , withMediaMediumDesktopUp
                [ margin2 (rem 0) (calc (vw -50) minus (px -575))
                , backgroundImage (url "/images/illustrations/1920px/about_2.png")
                , height (px 250)
                , backgroundSize (px 1920)
                , top (px -260)
                ]
            , withMediaSmallDesktopUp
                [ margin2 (rem 0) (rem -7)
                , backgroundImage (url "/images/illustrations/1366px/about_2.png")
                , backgroundSize (px 1367)
                , height (px 200)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_2.png")
                , height (px 280)
                , backgroundSize (px 1200)
                , top (px -250)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_2.png")
                , backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                , height (px 200)
                , top (px -190)
                , zIndex (int -1)
                ]
            ]
        , withMediaSmallDesktopUp
            [ marginTop (px 250) ]
        , withMediaTabletLandscapeUp
            [ marginTop (px 220) ]
        , withMediaTabletPortraitUp
            [ marginTop (px 200) ]
        ]


accessibilityCharactersStyle : Style
accessibilityCharactersStyle =
    batch
        [ position relative
        , before
            [ withMediaSmallDesktopUp
                [ width (px 244)
                , height (px 357)
                , backgroundSize (px 244)
                , left (px -100)
                ]
            , withMediaTabletLandscapeUp
                [ property "content" "\"\""
                , display block
                , width (px 182)
                , height (px 267)
                , backgroundSize (px 182)
                , backgroundPosition center
                , position absolute
                , zIndex (int 2)
                , backgroundRepeat noRepeat
                , backgroundImage (url "/images/characters/person_in_wheelchair.png")
                , top (px -190)
                , left (px 10)
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ width (px 429)
                , height (px 478)
                , backgroundSize (px 429)
                , right (px -100)
                , bottom (px -370)
                ]
            , withMediaTabletLandscapeUp
                [ property "content" "\"\""
                , display block
                , width (px 347)
                , height (px 386)
                , backgroundSize (px 347)
                , backgroundPosition center
                , position absolute
                , zIndex (int 2)
                , backgroundRepeat noRepeat
                , backgroundImage (url "/images/characters/nb_helmet_person.png")
                , bottom (px -50)
                , right (px -10)
                ]
            ]
        , withMediaTabletLandscapeUp
            [ important (paddingLeft (rem 10)), important (paddingRight (rem 10)) ]
        ]


aboutAccessibilityTextStyle : Style
aboutAccessibilityTextStyle =
    batch
        [ aboutTextStyle
        , descendants
            [ typeSelector "p"
                [ batch
                    [ withMediaMobileOnly
                        [ nthChild "3"
                            [ before
                                [ backgroundImage (url "/images/illustrations/320px/about_4.png")
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


makersStyle : Style
makersStyle =
    batch
        [ position relative
        , marginTop (px 250)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , height (px 230)
            , top (px -250)
            , backgroundImage (url "/images/illustrations/320px/about_5.png")
            , withMediaMediumDesktopUp
                [ margin2 (rem 0) (calc (vw -50) minus (px -575))
                , backgroundImage (url "/images/illustrations/1920px/about_3.png")
                , backgroundSize (px 1920)
                , height (px 250)
                , top (px -240)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/about_3.png")
                , margin2 (rem 0) (rem -14)
                , backgroundSize (px 1367)
                , height (px 200)
                , top (px -200)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_3.png")
                , backgroundSize (px 1200)
                , height (px 280)
                , top (px -210)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_3.png")
                , backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                , height (px 200)
                , top (px -190)
                , zIndex (int -1)
                ]
            ]
        , withMediaMediumDesktopUp
            [ marginTop (px 250) ]
        , withMediaSmallDesktopUp
            [ marginTop (px 200) ]
        , withMediaTabletLandscapeUp
            [ displayFlex, justifyContent spaceAround ]
        , withMediaTabletPortraitUp
            [ marginTop (px 150) ]
        ]


makerStyle : Style
makerStyle =
    batch
        [ marginTop (rem 3)
        , paddingBottom (rem 3)
        , marginBottom (rem 3)
        , position relative
        , withMediaSmallDesktopUp
            [ paddingLeft (rem 3)
            , paddingRight (rem 3)
            , paddingBottom (rem 3)
            ]
        , withMediaTabletLandscapeUp
            [ flexDirection column
            , width (pct 40)
            , marginTop (rem 1)
            ]
        , withMediaTabletPortraitUp
            [ displayFlex
            , alignItems center
            , paddingTop (rem 2)
            ]
        ]


makerHeaderStyle : Style
makerHeaderStyle =
    batch
        [ withMediaTabletLandscapeUp [ padding (rem 0) ]
        , withMediaTabletPortraitUp
            [ flexShrink (int 0)
            , paddingLeft (rem 1)
            , paddingRight (rem 3)
            ]
        ]


makerLogoStyle : Style
makerLogoStyle =
    batch
        [ width (px 200)
        , margin4 (rem 2) auto (rem 3) auto
        , withMediaSmallDesktopUp [ width (px 250) ]
        , withMediaTabletLandscapeUp [ margin4 (rem 1) auto (rem 3) auto ]
        , withMediaTabletPortraitUp [ margin (rem 0) ]
        ]


placeCalStyle : Style
placeCalStyle =
    batch
        [ position relative
        , marginTop (px 530)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , height (px 480)
            , top (px -520)
            , backgroundImage (url "/images/illustrations/320px/about_6.png")
            , withMediaMediumDesktopUp
                [ margin2 (rem 0) (calc (vw -50) minus (px -575))
                , backgroundImage (url "/images/illustrations/1920px/about_4.png")
                , height (px 250)
                , top (px -250)
                , backgroundSize (px 1920)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/about_4.png")
                , width (vw 100)
                , backgroundSize (px 1367)
                , height (px 200)
                , margin2 (rem 0) (rem -7)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_4.png")
                , backgroundSize (px 1200)
                , height (px 280)
                , top (px -230)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_4.png")
                , backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                , height (px 200)
                , top (px -190)
                , zIndex (int -1)
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ property "content" "\"\""
                , display block
                , width (px 186)
                , backgroundSize (px 186)
                , backgroundPosition center
                , position absolute
                , backgroundRepeat noRepeat
                , height (px 516)
                , left (px -80)
                , top (px -70)
                , backgroundImage (url "/images/characters/space_princess.png")
                ]
            ]
        , withMediaMediumDesktopUp
            [ marginTop (px 250) ]
        , withMediaTabletLandscapeUp
            [ marginTop (px 230) ]
        , withMediaTabletPortraitUp
            [ marginTop (px 200) ]
        ]


placeCalLogoStyle : Style
placeCalLogoStyle =
    batch
        [ width (px 200)
        , margin2 (rem 1) auto
        , withMediaTabletPortraitUp
            [ margin2 (rem 1.5) auto ]
        ]
