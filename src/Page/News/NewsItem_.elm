module Page.News.NewsItem_ exposing (..)

import Array exposing (Array)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (isValidUrl, t)
import Css exposing (Style, after, auto, batch, block, bold, borderRadius, center, display, firstChild, fontSize, fontWeight, height, margin, margin2, margin4, marginTop, maxWidth, pct, property, px, rem, textAlign, width)
import Css.Global exposing (descendants, typeSelector)
import Data.PlaceCal.Articles
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, article, div, figure, img, p, span, text, time)
import Html.Styled.Attributes exposing (alt, css, src)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Theme.Global exposing (viewBackButton, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Theme.TransMarkdown as TransMarkdown
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
        (\articlesData ->
            articlesData.allArticles
                |> List.map
                    (\newsItem ->
                        { newsItem = TransRoutes.stringToSlug newsItem.title
                        }
                    )
        )
        Data.PlaceCal.Articles.articlesData


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map2
        (\articlesData partnersData ->
            Maybe.withDefault Data.PlaceCal.Articles.emptyArticle
                ((articlesData.allArticles
                    |> List.filter (\newsItem -> TransRoutes.stringToSlug newsItem.title == routeParams.newsItem)
                 )
                    |> List.head
                )
                |> partnerIdsToNames partnersData
        )
        Data.PlaceCal.Articles.articlesData
        (DataSource.map (\partnersData -> partnersData.allPartners) Data.PlaceCal.Partners.partnersData)


partnerIdsToNames :
    List Data.PlaceCal.Partners.Partner
    -> Data.PlaceCal.Articles.Article
    -> Data.PlaceCal.Articles.Article
partnerIdsToNames partnersData newsItem =
    { newsItem | partnerIds = Data.PlaceCal.Partners.partnerNamesFromIds partnersData newsItem.partnerIds }


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = NewsItemTitle static.data.title
        , description = NewsItemMetaDescription static.data.title (String.join " & " static.data.partnerIds)
        , imageSrc = Nothing
        }


type alias Data =
    Data.PlaceCal.Articles.Article


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data.PlaceCal.Articles.Article RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t (PageMetaTitle static.data.title)
    , body =
        [ PageTemplate.view
            { headerType = Just "invisible"
            , title = t NewsTitle
            , bigText = { text = static.data.title, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (viewArticle static.data)
            , outerContent = Just viewPagination
            }
        ]
    }


viewArticle : Data.PlaceCal.Articles.Article -> Html Msg
viewArticle newsItem =
    article [ css [ articleStyle ] ]
        [ p [ css [ articleMetaStyle ] ]
            [ if List.length newsItem.partnerIds > 0 then
                span [ css [ newsItemAuthorStyle ] ]
                    [ text (String.join ", " newsItem.partnerIds) ]

              else
                text ""
            , time [] [ text (TransDate.humanDateFromPosix newsItem.publishedDatetime) ]
            ]
        , articleImage newsItem.maybeImage newsItem.body
        , div [ css [ articleContentStyle ] ] (TransMarkdown.markdownToHtml newsItem.body)
        ]


articleImage : Maybe String -> String -> Html Msg
articleImage maybeImage articleBody =
    figure [ css [ articleFigureStyle ] ]
        [ img [ src (articleImageSource maybeImage articleBody), css [ articleFigureImageStyle ], alt "" ] []
        ]


articleImageSource : Maybe String -> String -> String
articleImageSource maybeImage articleBody =
    let
        defaultImageUrl =
            Maybe.withDefault
                "/images/news/article_1.jpg"
                (Array.get
                    (modBy
                        (Array.length defaultNewsImages)
                        (String.length articleBody)
                    )
                    defaultNewsImages
                )
    in
    case maybeImage of
        Just imageUrl ->
            if isValidUrl imageUrl then
                imageUrl

            else
                defaultImageUrl

        Nothing ->
            defaultImageUrl


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


viewPagination : Html Msg
viewPagination =
    div []
        [ viewBackButton (TransRoutes.toAbsoluteUrl News) (t NewsItemReturnButton)
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
        , margin (rem 0)
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



{- not in use
   articleFigureCaptionStyle : Style
   articleFigureCaptionStyle =
       batch
           [ fontSize (rem 0.875)
           , textAlign center
           , margin (rem 0.75)
           , fontStyle italic
           ]
-}


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
