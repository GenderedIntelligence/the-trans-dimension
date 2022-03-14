module Page.Events exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, backgroundColor, batch, bold, center, color, displayFlex, fontSize, fontWeight, justifyContent, margin2, margin4, marginTop, padding4, rem, spaceBetween, textAlign)
import Data.PlaceCal.Events
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h2, h3, h4, li, p, section, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (blue, darkBlue)
import Time
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
    List Data.PlaceCal.Events.Event


data : DataSource (List Data.PlaceCal.Events.Event)
data =
    DataSource.map (\sharedData -> sharedData.allEvents) Data.PlaceCal.Events.eventsData


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = t SiteTitle
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t EventsMetaDescription
        , locale = Nothing
        , title = t EventsTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Events.Event) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t EventsTitle
    , body =
        [ viewHeader (t EventsTitle)
        , viewEvents static
        ]
    }


viewHeader : String -> Html msg
viewHeader title =
    section []
        [ h2 [ css [ Theme.Global.pageHeadingStyle ] ] [ text title ]
        ]


viewEvents : StaticPayload (List Data.PlaceCal.Events.Event) RouteParams -> Html msg
viewEvents events =
    section []
        [ viewEventsFilters
        , viewEventsList events
        ]


viewEventsFilters : Html msg
viewEventsFilters =
    div [ css [ featurePlaceholderStyle ] ]
        [ text "[fFf] Event filters"
        ]


viewEventsList : StaticPayload (List Data.PlaceCal.Events.Event) RouteParams -> Html msg
viewEventsList events =
    div []
        [ h3 [ css [ eventsHeadingStyle ] ] [ text (t EventsSubHeading) ]
        , div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Pagination by day/week" ]
        , if List.length events.data > 0 then
            ul [] (List.map (\event -> viewEvent event) events.data)

          else
            text ""
        ]


viewEvent : Data.PlaceCal.Events.Event -> Html msg
viewEvent event =
    li []
        [ article [ css [ eventStyle ] ]
            [ h4 [ css [ eventTitleStyle ] ] [ text event.name ]
            , time [] [ text (TransDate.humanDateFromPosix event.startDatetime) ]
            , time [] [ text (TransDate.humanTimeFromPosix event.startDatetime) ]

            --, p [ css [ eventParagraphStyle ] ] [ text (Data.PlaceCal.Events.realmToString event.realm) ]
            , p [ css [ eventParagraphStyle ] ] [ text event.location ]
            , a [ href (TransRoutes.toAbsoluteUrl (Event event.id)) ] [ text "View more" ]
            ]
        ]


eventsHeadingStyle : Style
eventsHeadingStyle =
    batch
        [ fontSize (rem 2)
        , textAlign center
        , margin4 (rem 2) (rem 0) (rem 1) (rem 0)
        ]


eventStyle : Style
eventStyle =
    batch
        [ backgroundColor blue
        , margin2 (rem 2) (rem 0)
        , padding4 (rem 1) (rem 2) (rem 1) (rem 1)
        , displayFlex
        , justifyContent spaceBetween
        ]


eventTitleStyle : Style
eventTitleStyle =
    batch
        [ color darkBlue
        ]


eventParagraphStyle : Style
eventParagraphStyle =
    batch
        [ marginTop (rem 0)
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , fontWeight bold
        ]
