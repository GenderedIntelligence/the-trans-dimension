module Page.Events.Event_ exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, a, div, h2, h3, li, main_, p, section, text, ul)
import Html.Styled.Attributes exposing (href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import TransDate
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { event : String }


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
            sharedData.events
                |> List.map (\event -> { event = event.id })
        )
        Shared.data


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\sharedData ->
            Maybe.withDefault Shared.emptyEvent
                ((sharedData.events
                    |> List.filter (\event -> event.id == routeParams.event)
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
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t (EventMetaDescription static.data.name)
        , locale = Nothing
        , title = t (EventMetaTitle static.data.name)
        }
        |> Seo.website


type alias Data =
    Shared.Event


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Shared.Event RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.name
    , body =
        [ main_ []
            [ viewHeader "Events"
            , viewInfo static.data
            ]
        ]
    }


viewHeader : String -> Html msg
viewHeader headerText =
    section [] [ h2 [] [ text headerText ] ]


viewInfo : Shared.Event -> Html msg
viewInfo event =
    section []
        [ h3 [] [ text event.name ]
        , div []
            [ p [] [ text (TransDate.humanDateFromPosix event.startDatetime) ]
            , p [] [ text (TransDate.humanTimeFromPosix event.startDatetime), text " - ", text (TransDate.humanTimeFromPosix event.endDatetime) ]
            , p [] [ text event.location ]
            , p [] [ text "online/offline" ]
            ]
        , div []
            [ p [] [ text event.description ]
            , ul [] [ li [] [ a [ href "/" ] [ text "link" ] ] ]
            ]
        ]
