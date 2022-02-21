module Page.Events exposing (Data, Model, Msg, page)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, backgroundColor, batch, bold, center, color, displayFlex, fontSize, fontWeight, justifyContent, margin2, margin4, marginTop, padding4, rem, spaceBetween, textAlign)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, article, div, h2, h3, h4, li, p, section, text, time, ul)
import Html.Styled.Attributes exposing (css)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme exposing (blue, darkBlue)
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
    List Shared.Event


data : DataSource (List Shared.Event)
data =
    DataSource.map (\sharedData -> sharedData.events) Shared.data


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
        , title = t EventsMetaTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Shared.Event) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t EventsMetaTitle
    , body =
        [ viewHeader (t EventsMetaTitle)
        , viewEvents static
        ]
    }


viewHeader : String -> Html msg
viewHeader title =
    section []
        [ h2 [ css [ Theme.pageHeadingStyle ] ] [ text title ]
        ]


viewEvents : StaticPayload (List Shared.Event) RouteParams -> Html msg
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


viewEventsList : StaticPayload (List Shared.Event) RouteParams -> Html msg
viewEventsList events =
    div []
        [ h3 [ css [ eventsHeadingStyle ] ] [ text "[cCc] Upcoming events" ]
        , div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Pagination by day/week" ]
        , ul [] (List.map (\event -> viewEvent event) events.data)
        ]


viewEvent : Shared.Event -> Html msg
viewEvent event =
    li []
        [ article [ css [ eventStyle ] ]
            [ h4 [ css [ eventTitleStyle ] ] [ text event.name ]
            , time [] [ text "Date" ]
            , time [] [ text "Time" ]
            , p [ css [ eventParagraphStyle ] ] [ text "Online?" ]
            , p [ css [ eventParagraphStyle ] ] [ text event.location ]
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