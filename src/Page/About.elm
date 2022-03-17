module Page.About exposing (Data, Model, Msg, page, view)

import Css exposing (Style, batch, height, rem)
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, div, h2, hr, section, text)
import Html.Styled.Attributes exposing (css)
import List exposing (concat)
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
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
    { title : String
    , body : List (Html.Html Msg)
    }


data : DataSource Data
data =
    DataSource.File.bodyWithFrontmatter
        (\markdownString ->
            Decode.map2
                (\title renderedMarkdown ->
                    { title = title
                    , body = renderedMarkdown
                    }
                )
                (Decode.field "title" Decode.string)
                (markdownString
                    |> TransMarkdown.markdownToView
                    |> Decode.fromResult
                )
        )
        "content/about.md"


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
    { title = static.data.title
    , body =
        concat
            [ [ viewHeader static.data.title ]
            , static.data.body
            , [ viewPageEnd ]
            ]
    }


viewHeader : String -> Html msg
viewHeader title =
    section []
        [ h2 [ css [] ] [ text title ]
        ]


viewPageEnd : Html msg
viewPageEnd =
    div [ css [ pageEndStyle ] ] []


pageEndStyle : Style
pageEndStyle =
    batch [ height (rem 3) ]
