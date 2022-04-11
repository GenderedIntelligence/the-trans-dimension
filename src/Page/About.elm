module Page.About exposing (Data, Model, Msg, page, view)

import Css exposing (Style, absolute, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, center, color, display, em, firstChild, fontSize, height, int, margin2, marginBlockEnd, marginTop, noRepeat, nthChild, paddingTop, pct, position, property, px, relative, rem, top, url, vw, width, zIndex)
import Css.Global exposing (descendants, typeSelector)
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, a, div, h2, h3, h4, hr, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, href, src, target)
import List exposing (concat)
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (contentContainerStyle, contentWrapperStyle, introTextLargeStyle, pink, smallFloatingTitleStyle, textBoxPinkStyle, withMediaMobileOnly)
import Theme.PageTemplate as PageTemplate exposing (HeaderType(..))
import Theme.TransMarkdown as TransMarkdown
import View exposing (View)
import Css exposing (marginBottom)
import Css exposing (margin)
import Css exposing (auto)
import Css exposing (margin4)
import Theme.Global exposing (viewFloatingButton)
import Theme.Global exposing (whiteBackgroundStyle)
import Css exposing (paddingBottom)


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
            { variant = AboutHeader
            , intro =
                { title = static.data.main.title
                , bigText = static.data.main.subtitle
                , smallText = []
                }
            }
            (Just (viewAboutIntro static))
            (Just (viewAboutSections static))
        ]
    }


viewAboutIntro : StaticPayload Data RouteParams -> Html.Html Msg
viewAboutIntro static =
    section [ css [ aboutIntroTextStyle ] ] static.data.main.body
    -- [fFf] from design wireframe - enter your email to be notified when we come to your area

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
        [ h3 [ css [ smallFloatingTitleStyle, top (rem -4.5) ] ] [ text static.data.accessibility.title ]
        , div [ css [ textBoxPinkStyle ] ] [ p [ css [ introTextLargeStyle ] ] [ text static.data.accessibility.subtitle ] ]
        , div [ css [ contentContainerStyle, aboutAccessibilityTextStyle ] ] static.data.accessibility.body
        ]


viewMakers : StaticPayload Data RouteParams -> Html.Html Msg
viewMakers static =
    section [ css [ makersStyle ]]
        (concat
            [ [ h3 [ css [ smallFloatingTitleStyle ]] [ text "Meet the Makers" ] ]
            , List.map (\maker -> viewMaker maker) static.data.makers
            ]
        )


viewMaker : Maker -> Html.Html Msg
viewMaker maker =
    div [ css [ textBoxPinkStyle, marginTop (rem 3), paddingBottom (rem 3), marginBottom (rem 3), position relative ]]
        [ h4 [] [  img [ src maker.logo, alt maker.name, css [ makerLogoStyle ] ] [] ]
        , div [ css [ normalFirstParagraphStyle ]] maker.body
        , viewFloatingButton maker.url "Find out more" whiteBackgroundStyle
       
        ]


viewAboutPlaceCal : StaticPayload Data RouteParams -> Html.Html Msg
viewAboutPlaceCal static =
    section [ css [ contentWrapperStyle, placeCalStyle ]]
        [ h3 [ css [ smallFloatingTitleStyle ]] [ text static.data.placecal.title ]
        , div [ css [ textBoxPinkStyle ]]
            [ img
                [ src static.data.placecal.subtitleimg
                , alt static.data.placecal.subtitleimgalt
                , css [ makerLogoStyle, marginTop (rem 1), marginBottom (rem 1) ]
                ]
                []
            ]
        , div [ css [ contentContainerStyle, normalFirstParagraphStyle ]] static.data.placecal.body
        ]

normalFirstParagraphStyle : Style
normalFirstParagraphStyle =
    batch 
        [ descendants
            [ typeSelector "p"
                [ batch
                    [ firstChild
                        [ fontSize (rem 1)
                        , marginBlockEnd (em 1)
                        ]
                ]]]]

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
        ]


aboutIntroTextStyle : Style
aboutIntroTextStyle =
    batch
        [ aboutTextStyle
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
            ]]

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

makerLogoStyle : Style
makerLogoStyle =
    batch
        [ width (px 200)
        , margin4 (rem 2) auto (rem 3) auto
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
            ]
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
            ]
        ]