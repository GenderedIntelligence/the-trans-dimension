module Page.Error404 exposing (Data, Model, Msg, page)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (viewBackButton)
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


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = ErrorTitle
        , description = ErrorMessage
        , imageSrc = Nothing
        }


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t (PageMetaTitle (t ErrorTitle))
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t ErrorTitle
            , bigText = { text = t ErrorMessage, node = "p" }
            , smallText = Nothing
            , innerContent = Nothing
            , outerContent = Just (viewBackButton (TransRoutes.toAbsoluteUrl Error) (t ErrorButtonText))
            }
        ]
    }
