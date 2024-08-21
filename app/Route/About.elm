module Route.About exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import BackendTask.File
import Css exposing (Style, absolute, after, alignItems, auto, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, bottom, calc, center, column, display, displayFlex, flexDirection, flexShrink, height, important, int, justifyContent, left, margin, margin2, margin4, marginBottom, marginLeft, marginRight, marginTop, maxWidth, minus, noRepeat, nthChild, padding, paddingBottom, paddingLeft, paddingRight, paddingTop, pct, position, property, px, relative, rem, right, spaceAround, top, url, vw, width, zIndex)
import Css.Global exposing (descendants, typeSelector)
import FatalError
import Head
import Html.Styled exposing (a, div, h3, h4, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Json.Decode as Decode
import PagesMsg
import RouteBuilder
import Shared
import Theme.AboutPage
import Theme.Global exposing (buttonFloatingWrapperStyle, contentContainerStyle, contentWrapperStyle, introTextLargeStyle, normalFirstParagraphStyle, smallFloatingTitleStyle, textBoxPinkStyle, whiteButtonStyle, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate
import Theme.TransMarkdown as TransMarkdown
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


route : RouteBuilder.StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildNoState
            { view = view }


type alias Data =
    { main : Theme.PageTemplate.SectionWithTextHeader Msg
    , accessibility : Theme.PageTemplate.SectionWithTextHeader Msg
    , makers : List Maker
    , placecal : Theme.PageTemplate.SectionWithImageHeader Msg
    }


type alias Maker =
    { name : String
    , url : String
    , logo : String
    , body : List (Html.Styled.Html Msg)
    }


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.map4
        (\main accessibility makers placecal ->
            { main = main
            , accessibility = accessibility
            , makers = makers
            , placecal = placecal
            }
        )
        (BackendTask.File.bodyWithFrontmatter
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
                        |> TransMarkdown.fromResult
                    )
            )
            "content/about/main.md"
        )
        (BackendTask.File.bodyWithFrontmatter
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
                        |> TransMarkdown.fromResult
                    )
            )
            "content/about/accessibility.md"
        )
        (BackendTask.map2
            (\gi gfsc ->
                [ gi, gfsc ]
            )
            (BackendTask.File.bodyWithFrontmatter
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
                            |> TransMarkdown.fromResult
                        )
                )
                "content/about/makers/gfsc.md"
            )
            (BackendTask.File.bodyWithFrontmatter
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
                            |> TransMarkdown.fromResult
                        )
                )
                "content/about/makers/gi.md"
            )
        )
        (BackendTask.File.bodyWithFrontmatter
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
                        |> TransMarkdown.fromResult
                    )
            )
            "content/about/placecal.md"
        )
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    []


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    { title = "About"
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "about"
            , title = app.data.main.title
            , bigText = { text = app.data.main.subtitle, node = "p" }
            , smallText = Nothing
            , innerContent = Just (Theme.AboutPage.viewIntro app.data.main.body)
            , outerContent =
                Just
                    (Theme.AboutPage.viewSections
                        { accessibilityData = app.data.accessibility
                        , makersData = app.data.makers
                        , aboutPlaceCalData = app.data.placecal
                        }
                    )
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
