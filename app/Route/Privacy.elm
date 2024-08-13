module Route.Privacy exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Html.Styled as Html
import OptimizedDecoder as Decode
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Theme.PageTemplate as PageTemplate
import Theme.TextHeavyPage as TextHeavyPage
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
    , subtitle : String
    , body : List (Html.Html Msg)
    }


data : DataSource Data
data =
    DataSource.File.bodyWithFrontmatter
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
        "content/privacy.md"


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = PrivacyTitle
        , description = PrivacyMetaDescription
        , imageSrc = Nothing
        }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t (PageMetaTitle (t PrivacyTitle))
    , body = [ TextHeavyPage.view static.data.title static.data.subtitle static.data.body ]
    }
