module Page.Partners.Partner_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
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
    { partner : String }


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
            sharedData.partners
                |> List.map (\partner -> { partner = partner.id })
        )
        Shared.data


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\sharedData ->
            -- There probably a better patter than succeed with empty.
            -- In theory all will succeed since routes mapped from same list.
            Maybe.withDefault Shared.emptyPartner
                ((sharedData.partners
                    -- Filter for partner with matching id
                    |> List.filter (\partner -> partner.id == routeParams.partner)
                 )
                    -- There should only be one, so take the head
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


type alias Data =
    Shared.Partner


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    View.placeholder "Partners.Partner_"
