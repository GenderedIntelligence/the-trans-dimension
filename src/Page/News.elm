module Page.News exposing (Data, Model, Msg, page, view)

import Array exposing (Array)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, after, auto, backgroundColor, batch, block, borderBox, borderRadius, bottom, boxSizing, calc, center, color, display, displayFlex, flexGrow, fontSize, fontStyle, fontWeight, height, int, italic, left, margin, margin2, margin4, marginBottom, marginRight, marginTop, maxWidth, none, padding, padding4, paddingLeft, paddingRight, pct, position, property, px, relative, rem, textAlign, textDecoration, width)
import Data.PlaceCal.Articles
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h2, h3, img, li, main_, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href, src)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (darkBlue, pink, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
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


type alias Data =
    List Data.PlaceCal.Articles.Article


data : DataSource (List Data.PlaceCal.Articles.Article)
data =
    DataSource.map (\sharedData -> sharedData.allArticles) Data.PlaceCal.Articles.articlesData


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
        , description = t NewsDescription
        , locale = Nothing
        , title = t NewsTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Articles.Article) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t NewsTitle
    , body =
        [ PageTemplate.view { title = t NewsTitle, bigText = t NewsDescription, smallText = [] }
            Nothing
            (Just
                (div []
                    [ viewNewsList static
                    , viewPagination
                    ]
                )
            )
        ]
    }


viewNewsList : StaticPayload (List Data.PlaceCal.Articles.Article) RouteParams -> Html Msg
viewNewsList news =
    section []
        [ if List.length news.data == 0 then
            p [] [ text (t NewsEmptyText) ]

          else
            ul [] (List.map (\newsItem -> viewNewsItem newsItem) news.data)
        ]


defaultNewsImages : Array String
defaultNewsImages =
    Array.fromList
        [ "images/news/article_1.jpg"
        , "images/news/article_2.jpg"
        , "images/news/article_3.jpg"
        , "images/news/article_4.jpg"
        , "images/news/article_5.jpg"
        , "images/news/article_6.jpg"
        ]


viewNewsItem : Data.PlaceCal.Articles.Article -> Html msg
viewNewsItem newsItem =
    li [ css [ newsItemStyle ] ]
        [ article [ css [ newsItemArticleStyle ] ]
            [ img
                [ src
                    (case Array.get 0 defaultNewsImages of
                        Just string ->
                            string

                        Nothing ->
                            ""
                    )
                , css [ newsImageStyle ]
                ]
                []
            , div [ css [ newsItemInfoStyle ] ]
                [ h3 [ css [ newsItemTitleStyle ] ] [ text newsItem.title ]
                , p [ css [ newsItemMetaStyle ] ]
                    [ span [ css [ newsItemAuthorStyle ] ] [ text "[fFf] Get partner name from id" ]
                    , time [] [ text (TransDate.humanDateFromPosix newsItem.publishedDatetime) ]
                    ]
                , p [ css [ newsItemSummaryStyle ] ] [ text (summaryFromArticleBody newsItem.body) ]
                ]
            , div [ css [ buttonWrapperStyle ] ]
                [ a
                    [ css [ buttonStyle ]
                    , href
                        (TransRoutes.toAbsoluteUrl
                            (NewsItem (TransRoutes.stringToSlug newsItem.title))
                        )
                    ]
                    [ text (t NewsReadMore) ]
                ]
            ]
        ]


viewPagination : Html msg
viewPagination =
    ul [] [ text "[fFf] News pagination" ]


summaryFromArticleBody : String -> String
summaryFromArticleBody articleBody =
    "[fFf] Summary"



---------
-- Styles
---------


newsItemStyle : Style
newsItemStyle =
    batch
        [ margin4 (rem 2) (rem 0) (rem 3) (rem 0)
        , backgroundColor white
        , color darkBlue
        , borderRadius (rem 0.2)
        , padding4 (rem 1.25) (rem 1.25) (rem 3) (rem 1.25)
        , position relative
        , boxSizing borderBox
        , withMediaSmallDesktopUp [ maxWidth (px 920), margin4 (rem 4) auto (rem 5) auto ]
        , withMediaTabletLandscapeUp [ margin (rem 3), padding (rem 2) ]
        , withMediaTabletPortraitUp [ padding (rem 3) ]
        ]


newsItemArticleStyle : Style
newsItemArticleStyle =
    batch
        [ withMediaTabletPortraitUp [ displayFlex ] ]


newsImageStyle : Style
newsImageStyle =
    batch
        [ width (pct 100)
        , height (pct 56.25)
        , property "object-fit" "cover"
        , borderRadius (rem 0.3)
        , marginBottom (rem 1)
        , withMediaSmallDesktopUp [ marginTop (rem 1) ]
        , withMediaTabletLandscapeUp [ width (px 303) ]
        , withMediaTabletPortraitUp [ width (px 294) ]
        ]


newsItemInfoStyle : Style
newsItemInfoStyle =
    batch
        [ withMediaTabletPortraitUp
            [ flexGrow (int 1)
            , paddingLeft (rem 2)
            ]
        ]


newsItemTitleStyle : Style
newsItemTitleStyle =
    batch
        [ fontWeight (int 400)
        , fontStyle italic
        , textAlign center
        , fontSize (rem 1.85)
        , withMediaTabletPortraitUp [ textAlign left ]
        ]


newsItemMetaStyle : Style
newsItemMetaStyle =
    batch
        [ fontWeight (int 600)
        , textAlign center
        , withMediaTabletLandscapeUp [ margin2 (rem 1) (rem 0) ]
        , withMediaTabletPortraitUp [ textAlign left ]
        ]


newsItemAuthorStyle : Style
newsItemAuthorStyle =
    batch
        [ after [ property "content" "\"•\"", margin2 (rem 0) (rem 0.25) ]
        , withMediaTabletPortraitUp [ textAlign left ]
        ]


newsItemSummaryStyle : Style
newsItemSummaryStyle =
    batch
        [ textAlign center
        , marginTop (rem 0.5)
        , withMediaTabletPortraitUp [ textAlign left, fontSize (rem 1.2) ]
        ]


buttonWrapperStyle : Style
buttonWrapperStyle =
    batch
        [ margin2 (rem 1) auto
        , display block
        , position absolute
        , bottom (rem -2)
        , textAlign center
        , width (pct 100)
        ]


buttonStyle : Style
buttonStyle =
    batch
        [ backgroundColor pink
        , color darkBlue
        , textDecoration none
        , padding4 (rem 0.375) (rem 1.25) (rem 0.5) (rem 1.25)
        , borderRadius (rem 0.3)
        , fontWeight (int 600)
        , marginRight (rem 1.75)
        , fontSize (rem 1.2)
        ]
