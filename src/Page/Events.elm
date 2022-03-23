module Page.Events exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, backgroundColor, batch, block, bold, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderRadius, boxSizing, calc, center, color, column, display, displayFlex, em, flexDirection, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, int, italic, justifyContent, letterSpacing, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, minus, none, padding2, padding4, paddingBottom, pct, px, rem, row, rowReverse, solid, spaceBetween, sub, textAlign, textDecoration, textTransform, uppercase, width, wrap)
import Css.Transitions exposing (font)
import Data.PlaceCal.Events
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h2, h3, h4, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (blue, darkBlue, darkPurple, pink, purple, white, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
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
        [ PageTemplate.view
            { title = t EventsTitle
            , bigText = t EventsSummary
            , smallText = []
            }
            (viewEvents static)
            (Just viewSubscribe)
        ]
    }


viewEvents : StaticPayload (List Data.PlaceCal.Events.Event) RouteParams -> Html msg
viewEvents events =
    section []
        [ viewEventsFilters
        , viewPagination
        , viewEventsList events
        ]


viewEventsFilters : Html msg
viewEventsFilters =
    div [ css [ featurePlaceholderStyle ] ]
        [ text "[fFf] Event filters"
        ]


viewPagination : Html msg
viewPagination =
    div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Pagination by day/week" ]


viewEventsList : StaticPayload (List Data.PlaceCal.Events.Event) RouteParams -> Html msg
viewEventsList events =
    div []
        [ if List.length events.data > 0 then
            ul [ css [ eventListStyle ] ] (List.map (\event -> viewEvent event) events.data)

          else
            text ""
        ]


viewEvent : Data.PlaceCal.Events.Event -> Html msg
viewEvent event =
    li [ css [ eventListItemStyle ] ]
        [ article [ css [ eventStyle ] ]
            [ div [ css [ eventDescriptionStyle ] ]
                [ h4 [ css [ eventTitleStyle ] ] [ a [ css [ eventLinkStyle ], href (TransRoutes.toAbsoluteUrl (Event event.id)) ] [ text event.name ] ]
                , div []
                    [ p [ css [ eventParagraphStyle ] ]
                        [ time [] [ text (TransDate.humanTimeFromPosix event.startDatetime) ]
                        , span [] [ text " — " ]
                        , time [] [ text (TransDate.humanTimeFromPosix event.endDatetime) ]
                        ]

                    --, p [ css [ eventParagraphStyle ] ] [ text (Data.PlaceCal.Events.realmToString event.realm) ]
                    , p [ css [ eventParagraphStyle ] ] [ text event.location ]
                    , p [ css [ eventParagraphStyle ] ] [ text ("by " ++ event.partnerId) ] -- [fFf] get partner name from id
                    ]
                ]
            , div []
                [ time [ css [ eventDateStyle ] ]
                    [ span [ css [ eventDayStyle ] ]
                        [ text (TransDate.humanDayFromPosix event.startDatetime) ]
                    , span [ css [ eventMonthStyle ] ]
                        [ text (TransDate.humanShortMonthFromPosix event.startDatetime) ]
                    ]
                ]
            ]
        ]


viewSubscribe : Html msg
viewSubscribe =
    div
        [ css [ subscribeBoxStyle ] ]
        [ p
            [ css [ subscribeTextStyle ] ]
            [ a [ css [ subscribeLinkStyle ] ] [ text (t EventsSubscribeText) ] ]
        ]


eventListStyle : Style
eventListStyle =
    batch
        [ displayFlex
        , flexDirection column
        , padding2 (rem 2) (rem 0)
        , withMediaTabletLandscapeUp [ flexDirection row, flexWrap wrap, margin2 (rem 0) (rem -1) ]
        ]


eventListItemStyle : Style
eventListItemStyle =
    batch
        [ withMediaTabletLandscapeUp [ width (calc (pct 50) minus (rem 2)), margin2 (rem 0) (rem 1) ] ]


eventStyle : Style
eventStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , flexDirection rowReverse
        , margin2 (rem 1.25) (rem 0.25)
        , withMediaTabletPortraitUp [ margin2 (rem 1.5) (rem 0) ]
        ]


eventDateStyle : Style
eventDateStyle =
    batch
        [ displayFlex
        , flexDirection column
        , alignItems center
        , marginRight (rem 1)
        ]


eventDayStyle : Style
eventDayStyle =
    batch
        [ color white
        , fontSize (rem 2.5)
        , display block
        , lineHeight (em 1)
        , withMediaTabletPortraitUp [ fontSize (rem 3.1222), marginTop (rem -0.75) ]
        ]


eventMonthStyle : Style
eventMonthStyle =
    batch
        [ color pink
        , textTransform uppercase
        , fontSize (rem 1.2)
        , fontWeight (int 900)
        , letterSpacing (px 1.9)
        ]


eventDescriptionStyle : Style
eventDescriptionStyle =
    batch
        [ flexGrow (int 1) ]


eventTitleStyle : Style
eventTitleStyle =
    batch
        [ color white
        , fontStyle italic
        , fontSize (rem 1.2)
        , fontWeight (int 500)
        , lineHeight (rem 1.25)
        , paddingBottom (rem 0.5)
        , marginBottom (rem 0.5)
        , borderBottomWidth (px 2)
        , borderBottomColor pink
        , borderBottomStyle solid
        , withMediaTabletPortraitUp [ fontSize (rem 1.5), lineHeight (rem 1.877) ]
        ]


eventLinkStyle : Style
eventLinkStyle =
    batch
        [ textDecoration none
        , color white
        ]


eventParagraphStyle : Style
eventParagraphStyle =
    batch
        [ marginBlockStart (rem 0)
        , marginBlockEnd (rem 0)
        , margin (rem 0)
        , fontSize (rem 0.8777)
        , withMediaTabletPortraitUp [ fontSize (rem 1.2), lineHeight (rem 1.75) ]
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , backgroundColor darkPurple
        ]


subscribeBoxStyle : Style
subscribeBoxStyle =
    batch
        [ padding2 (rem 0.75) (rem 1.5)
        , backgroundColor darkPurple
        , borderRadius (rem 0.3)
        ]


subscribeTextStyle : Style
subscribeTextStyle =
    batch
        [ textTransform uppercase
        , color pink
        , textAlign center
        , fontSize (rem 1.1)
        , letterSpacing (px 1.9)
        , fontWeight (int 700)
        ]


subscribeLinkStyle : Style
subscribeLinkStyle =
    batch
        [ color pink, textDecoration none ]
