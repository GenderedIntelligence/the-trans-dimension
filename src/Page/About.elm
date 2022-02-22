module Page.About exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
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
    , body : String
    }


data : DataSource Data
data =
    DataSource.File.bodyWithFrontmatter
        aboutPageDecoder
        "content/about.md"


aboutPageDecoder : String -> Decoder Data
aboutPageDecoder body =
    Decode.map (Data body)
        (Decode.field "title" Decode.string)


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
    , body = [ Html.text static.data.withoutFrontmatter ]
    }
