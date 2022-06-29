module Page.News exposing (Data, Model, Msg, page, view, viewNewsArticle)

import Array exposing (Array)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, after, auto, backgroundColor, batch, borderBox, borderRadius, boxSizing, calc, center, color, displayFlex, em, flexGrow, fontSize, fontStyle, fontWeight, height, int, italic, left, lineHeight, margin, margin2, margin4, marginBottom, marginTop, maxWidth, minus, padding, padding4, paddingLeft, pct, position, property, px, relative, rem, textAlign, width)
import Data.PlaceCal.Articles
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h3, img, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href, src)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Theme.Global exposing (buttonFloatingWrapperStyle, darkBlue, pinkButtonOnLightBackgroundStyle, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
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
    DataSource.map2
        (\articleData partnerData ->
            List.map
                (\article ->
                    { article | partnerIds = Data.PlaceCal.Partners.partnerNamesFromIds partnerData article.partnerIds }
                )
                articleData.allArticles
        )
        Data.PlaceCal.Articles.articlesData
        (DataSource.map (\partnersData -> partnersData.allPartners) Data.PlaceCal.Partners.partnersData)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = NewsTitle
        , description = NewsDescription
        , imageSrc = Nothing
        }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Articles.Article) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t NewsTitle
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t NewsTitle
            , bigText = { text = t NewsDescription, node = "h3" }
            , smallText = Nothing
            , innerContent = Nothing
            , outerContent =
                Just
                    (div []
                        [ viewNewsList static
                        ]
                    )
            }
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
        [ "/images/news/article_1.jpg"
        , "/images/news/article_2.jpg"
        , "/images/news/article_3.jpg"
        , "/images/news/article_4.jpg"
        , "/images/news/article_5.jpg"
        , "/images/news/article_6.jpg"
        ]


viewNewsItem : Data.PlaceCal.Articles.Article -> Html msg
viewNewsItem newsItem =
    li [ css [ newsItemStyle ] ]
        [ viewNewsArticle newsItem ]


viewNewsArticle : Data.PlaceCal.Articles.Article -> Html msg
viewNewsArticle newsItem =
    article [ css [ newsItemArticleStyle ] ]
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
                [ if List.length newsItem.partnerIds > 0 then
                    span [ css [ newsItemAuthorStyle ] ]
                        [ text (String.join ", " newsItem.partnerIds) ]

                  else
                    text ""
                , time [] [ text (TransDate.humanDateFromPosix newsItem.publishedDatetime) ]
                ]
            , p [ css [ newsItemSummaryStyle ] ] [ text (summaryFromArticleBody newsItem.body), text "..." ]
            ]
        , div [ css [ buttonFloatingWrapperStyle, width (calc (pct 100) minus (rem 2)) ] ]
            [ a
                [ css [ pinkButtonOnLightBackgroundStyle ]
                , href
                    (TransRoutes.toAbsoluteUrl
                        (NewsItem (TransRoutes.stringToSlug newsItem.title))
                    )
                ]
                [ text (t (NewsItemReadMore newsItem.title)) ]
            ]
        ]


summaryFromArticleBody : String -> String
summaryFromArticleBody articleBody =
    String.words articleBody
        |> List.take 20
        |> String.join " "



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
        , withMediaTabletPortraitUp [ width (px 294), maxWidth (pct 50) ]
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
        , lineHeight (em 1.3)
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
