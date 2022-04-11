module Page.News.NewsItem_ exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, after, auto, backgroundColor, batch, block, bold, borderRadius, center, color, display, firstChild, fontSize, fontWeight, height, inlineBlock, margin, margin2, margin4, marginBottom, marginTop, maxWidth, none, num, padding, pct, property, px, rem, textAlign, textDecoration, width)
import Css.Global exposing (descendants, typeSelector)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, figcaption, figure, h2, h3, img, li, main_, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href, src)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate exposing (HeaderType(..))
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { newsItem : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.map
        (\sharedData ->
            sharedData.news
                |> List.map (\newsItem -> { newsItem = newsItem.id })
        )
        Shared.data


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\sharedData ->
            Maybe.withDefault Shared.emptyNews
                ((sharedData.news
                    |> List.filter (\newsItem -> newsItem.id == routeParams.newsItem)
                 )
                    |> List.head
                )
        )
        Shared.data


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
        , description = t (NewsItemDescription static.data.title)
        , locale = Nothing
        , title = t (NewsItemTitle static.data.title)
        }
        |> Seo.website


type alias Data =
    Shared.News


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Shared.News RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body =
        [ PageTemplate.view
            { variant = InvisibleHeader
            , intro =
                { title = t NewsTitle
                , bigText = static.data.title
                , smallText = []
                }
            }
            (Just
                (viewArticle
                    static.data
                )
            )
            (Just
                viewPagination
            )
        ]
    }


viewArticle : Shared.News -> Html msg
viewArticle newsItem =
    article [ css [ articleStyle ] ]
        [ p [ css [ articleMetaStyle ] ]
            [ span [ css [ newsItemAuthorStyle ] ] [ text newsItem.author ]
            , time [] [ text (TransDate.humanDateFromPosix newsItem.datetime) ]
            ]
        , figure [ css [ articleFigureStyle ] ]
            [ img [ src "/images/news/article_6.jpg", css [ articleFigureImageStyle ] ] [] -- [fFf]
            , figcaption [ css [ articleFigureCaptionStyle ] ] [ text "Optional image credit, note and or details." ] -- [fFf]
            ]
        , div [ css [ articleContentStyle ] ] [ text newsItem.body ]
        ]


viewPagination : Html msg
viewPagination =
    div []
        [ p [ css [ goBackStyle ] ] [ text "[fFf] Previous/next navigation" ]
        , a
            [ href (TransRoutes.toAbsoluteUrl News)
            , css [ goBackStyle ]
            ]
            [ text (t NewsItemReturnButton) ]
        ]


articleStyle : Style
articleStyle =
    batch
        [ margin2 (rem 0) (rem 0.25)
        , withMediaTabletLandscapeUp [ maxWidth (px 636), margin2 (rem 0) auto ]
        ]


articleMetaStyle : Style
articleMetaStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , display block
        , margin2 (rem 2) (rem 0)
        , withMediaTabletPortraitUp [ margin4 (rem 0) (rem 2) (rem 3) (rem 2) ]
        ]


articleFigureStyle : Style
articleFigureStyle =
    batch
        [ margin2 (rem 2) (rem 0)
        , withMediaSmallDesktopUp [ marginTop (rem 5) ]
        , withMediaTabletLandscapeUp [ margin2 (rem 2) (rem 0) ]
        , withMediaTabletPortraitUp [ margin2 (rem 2) (rem 1) ]
        ]


articleFigureImageStyle : Style
articleFigureImageStyle =
    batch
        [ width (pct 100)
        , height (pct 56.25)
        , property "object-fit" "cover"
        , borderRadius (rem 0.3)
        ]


articleFigureCaptionStyle : Style
articleFigureCaptionStyle =
    batch
        [ fontSize (rem 0.875)
        , textAlign center
        , margin2 (rem 0.75) (rem 0)
        ]


articleContentStyle : Style
articleContentStyle =
    batch
        [ margin2 (rem 4) (rem 0)
        , withMediaTabletPortraitUp [ maxWidth (px 636), margin2 (rem 4) auto, fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ maxWidth (px 560), margin2 (rem 4) auto ]
        , descendants
            [ typeSelector "p"
                [ batch
                    [ firstChild
                        [ fontSize (rem 2) ]
                    ]
                ]
            ]
        ]


newsItemAuthorStyle : Style
newsItemAuthorStyle =
    batch
        [ after [ property "content" "\"•\"", margin2 (rem 0) (rem 0.25) ]
        ]


goBackStyle : Style
goBackStyle =
    batch
        [ backgroundColor Theme.Global.darkBlue
        , color Theme.Global.white
        , textDecoration none
        , padding (rem 1)
        , display block
        , width (pct 25)
        , margin2 (rem 2) auto
        , textAlign center
        ]
