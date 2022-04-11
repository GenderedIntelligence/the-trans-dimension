module Page.About exposing (Data, Model, Msg, page, view)

import Css exposing (Style, batch, height, rem)
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, div, h2, h3, hr, section, text, a)
import Html.Styled.Attributes exposing (css, href)
import List exposing (concat)
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
import Theme.TransMarkdown as TransMarkdown
import View exposing (View)
import Theme.PageTemplate as PageTemplate
import Html.Styled exposing (h4)
import Html.Styled exposing (img)
import Html.Styled.Attributes exposing (src)

import Html.Styled.Attributes exposing (target)


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
    { name : String, url : String, logo : String , body : List (Html.Html Msg)}


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
            ) "content/about/main.md" )
        ( DataSource.File.bodyWithFrontmatter
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
            ) "content/about/accessibility.md" )
        ( DataSource.map2 
            (\ gi gfsc ->
                [ gi, gfsc]
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
            ) "content/about/makers/gi.md" )
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
            ) "content/about/makers/gfsc.md" ) )
        ( DataSource.File.bodyWithFrontmatter
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
            ) "content/about/placecal.md" )
    


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
        [ PageTemplate.view { title = static.data.main.title , bigText = static.data.main.subtitle, smallText = [] } (Just (section []  static.data.main.body)) (Just (div [] (viewAbout static))) ]
        
    }


viewAbout : StaticPayload Data RouteParams -> List (Html.Html Msg)
viewAbout static =
    [ section [] [ h3 [] [ text static.data.accessibility.title ]
                 , h4 [] [ text static.data.accessibility.subtitle ]
                 , div [] static.data.accessibility.body
                 ]
    , section [] (List.map (\maker -> (viewMaker maker)) static.data.makers)
    ]

viewMaker maker =
     section [] [ h4 [] [ text maker.name]
                , img [ src maker.logo ] []
                , div [] maker.body 
                , a [ href maker.url, target "_blank"] [ text "Find out more about ", text maker.name]]