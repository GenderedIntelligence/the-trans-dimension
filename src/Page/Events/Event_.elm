module Page.Events.Event_ exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, batch, bold, center, fontSize, fontWeight, margin, margin4, marginBottom, marginTop, num, rem, textAlign)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, a, div, h2, h3, li, main_, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import PlaceCalTypes
import Shared
import Theme
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
            Maybe.withDefault PlaceCalTypes.emptyEvent
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
    PlaceCalTypes.Event


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload PlaceCalTypes.Event RouteParams
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
    section [] [ h2 [ css [ Theme.pageHeadingStyle ] ] [ text headerText ] ]


viewInfo : PlaceCalTypes.Event -> Html msg
viewInfo event =
    section []
        [ h3 [ css [ eventSubheadingStyle ] ] [ text event.name ]
        , div []
            [ p [ css [ eventMetaStyle ] ] [ text (TransDate.humanDateFromPosix event.startDatetime) ]
            , p [ css [ eventMetaStyle ] ] [ text (TransDate.humanTimeFromPosix event.startDatetime), text " - ", text (TransDate.humanTimeFromPosix event.endDatetime) ]
            , p [ css [ eventMetaStyle ] ] [ text event.location ]
            , p [ css [ eventMetaStyle ] ]
                [ text
                    (PlaceCalTypes.realmToString event)
                ]
            ]
        , div [ css [ eventDescriptionStyle ] ]
            [ p [] [ text event.description ]
            , ul [] [ li [] [ a [ href "/" ] [ text "link [fFf]" ] ] ]
            ]
        ]


eventSubheadingStyle : Style
eventSubheadingStyle =
    batch
        [ fontSize (rem 2)
        , textAlign center
        , margin4 (rem 0) (rem 0) (rem 1) (rem 0)
        ]


eventDescriptionStyle : Style
eventDescriptionStyle =
    batch
        [ marginTop (rem 1)
        , marginBottom (rem 2)
        ]


eventMetaStyle : Style
eventMetaStyle =
    batch
        [ fontWeight bold
        , margin (rem 0)
        , textAlign center
        ]
