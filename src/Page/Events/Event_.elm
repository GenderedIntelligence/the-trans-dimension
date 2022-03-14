module Page.Events.Event_ exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, auto, backgroundColor, batch, block, bold, center, color, display, fontSize, fontWeight, hover, margin, margin2, margin4, marginBottom, marginTop, none, num, padding, pct, rem, textAlign, textDecoration, width)
import Data.PlaceCal.Events
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h2, h3, li, main_, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
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
            sharedData.allEvents
                |> List.map (\event -> { event = event.id })
        )
        Data.PlaceCal.Events.eventsData


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map
        (\sharedData ->
            Maybe.withDefault Data.PlaceCal.Events.emptyEvent
                ((sharedData.allEvents
                    |> List.filter (\event -> event.id == routeParams.event)
                 )
                    |> List.head
                )
        )
        Data.PlaceCal.Events.eventsData


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
        , title = t (EventTitle static.data.name)
        }
        |> Seo.website


type alias Data =
    Data.PlaceCal.Events.Event


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data.PlaceCal.Events.Event RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.name
    , body =
        [ viewHeader (t EventsTitle)
        , viewInfo static.data
        , div [] [ text "[fFf] Map" ]
        , viewGoBack (t BackToEventsLinkText)
        ]
    }


viewHeader : String -> Html msg
viewHeader headerText =
    section [] [ h2 [ css [ Theme.Global.pageHeadingStyle ] ] [ text headerText ] ]


viewInfo : Data.PlaceCal.Events.Event -> Html msg
viewInfo event =
    section []
        [ h3 [ css [ eventSubheadingStyle ] ] [ text event.name ]
        , div []
            [ p [ css [ eventMetaStyle ] ] [ text (TransDate.humanDateFromPosix event.startDatetime) ]
            , p [ css [ eventMetaStyle ] ] [ text (TransDate.humanTimeFromPosix event.startDatetime), text " - ", text (TransDate.humanTimeFromPosix event.endDatetime) ]
            , p [ css [ eventMetaStyle ] ] [ text event.location ]
            , p [ css [ eventMetaStyle ] ]
                [ text
                    (Data.PlaceCal.Events.realmToString event.realm)
                ]
            ]
        , div [ css [ eventDescriptionStyle ] ]
            [ p [] [ text event.description ]
            , ul [] [ li [] [ a [ href "https://example.com/[cCc]" ] [ text "link [fFf]" ] ] ]
            ]
        ]


viewGoBack : String -> Html msg
viewGoBack buttonText =
    a
        [ href (TransRoutes.toAbsoluteUrl Events)
        , css [ goBackStyle ]
        ]
        [ text buttonText ]


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


goBackStyle : Style
goBackStyle =
    batch
        [ backgroundColor Theme.Global.darkBlue
        , color Theme.Global.white
        , textDecoration none
        , padding (rem 1)
        , display block
        , width (pct 25)
        , margin2 (rem 2) auto
        , textAlign center
        , hover [ backgroundColor Theme.Global.blue, color Theme.Global.black ]
        ]
