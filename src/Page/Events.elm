module Page.Events exposing (Data, Model, Msg, addPartnerNamesToEvents, page, view, viewEventsList)

import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, backgroundColor, batch, block, bold, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderRadius, boxSizing, calc, center, color, column, display, displayFlex, em, firstChild, flexDirection, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, hover, int, italic, justifyContent, lastChild, letterSpacing, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, minus, none, padding2, padding4, paddingBottom, pct, px, rem, row, rowReverse, solid, spaceBetween, sub, textAlign, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, button, div, h2, h3, h4, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import Task
import Theme.Global exposing (blue, borderTransition, colorTransition, darkBlue, darkPurple, pink, purple, white, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Time
import View exposing (View)


type alias Model =
    { filterByDay : Maybe Time.Posix
    , visibleEvents : List Data.PlaceCal.Events.Event
    , nowTime : Time.Posix
    }


type Msg
    = ClickedDay Time.Posix
    | ClickedAllEvents
    | GetTime Time.Posix


type alias RouteParams =
    {}


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( { filterByDay = Nothing
      , visibleEvents = static.data
      , nowTime = Time.millisToPosix 0
      }
    , Task.perform GetTime Time.now
    )


update :
    PageUrl
    -> Maybe Browser.Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update pageUrl maybeNavigationKey sharedModel static msg localModel =
    case msg of
        ClickedDay posix ->
            ( { localModel
                | filterByDay = Just posix
                , visibleEvents =
                    List.filter
                        (\event ->
                            TransDate.isSameDay event.startDatetime posix
                        )
                        static.data
              }
            , Cmd.none
            )

        ClickedAllEvents ->
            ( { localModel
                | filterByDay = Nothing
                , visibleEvents = static.data
              }
            , Cmd.none
            )

        GetTime newTime ->
            ( { localModel | nowTime = newTime }, Cmd.none )


subscriptions :
    Maybe PageUrl
    -> RouteParams
    -> Path
    -> Model
    -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


page : PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


type alias Data =
    List Data.PlaceCal.Events.Event


data : DataSource (List Data.PlaceCal.Events.Event)
data =
    DataSource.map2
        (\eventData partnerData -> addPartnerNamesToEvents eventData.allEvents partnerData.allPartners)
        Data.PlaceCal.Events.eventsData
        Data.PlaceCal.Partners.partnersData


addPartnerNamesToEvents : List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Partners.Partner -> List Data.PlaceCal.Events.Event
addPartnerNamesToEvents events partners =
    List.map
        (\event ->
            { event
                | partner =
                    setPartnerName event.partner (Data.PlaceCal.Partners.partnerNameFromId partners event.partner.id)
            }
        )
        events


setPartnerName : Data.PlaceCal.Events.EventPartner -> Maybe String -> Data.PlaceCal.Events.EventPartner
setPartnerName oldEventPartner partnerName =
    { oldEventPartner | name = partnerName }


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
    -> Model
    -> StaticPayload (List Data.PlaceCal.Events.Event) RouteParams
    -> View Msg
view maybeUrl sharedModel localModel static =
    { title = t EventsTitle
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = t EventsSummary, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (viewEvents localModel)
            , outerContent = Just viewSubscribe
            }
        ]
    }


viewEvents :
    Model
    -> Html Msg
viewEvents localModel =
    section []
        [ viewEventsFilters localModel
        , viewPagination localModel
        , viewEventsList localModel.visibleEvents
        ]


viewEventsFilters : Model -> Html Msg
viewEventsFilters localModel =
    div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Event filters" ]


viewPagination : Model -> Html Msg
viewPagination localModel =
    div []
        [ ul [ css [ paginationButtonListStyle ] ]
            (List.map
                (\( label, buttonTime ) -> li [] [ button [ Html.Styled.Events.onClick (ClickedDay buttonTime) ] [ text label ] ])
                (todayTomorrowNext5DaysPosix localModel.nowTime)
                ++ [ li []
                        [ button
                            [ Html.Styled.Events.onClick ClickedAllEvents ]
                            [ text (t EventsFilterLabelAll) ]
                        ]
                   ]
            )
        ]


todayTomorrowNext5DaysPosix : Time.Posix -> List ( String, Time.Posix )
todayTomorrowNext5DaysPosix now =
    [ ( t EventsFilterLabelToday, now )
    , ( t EventsFilterLabelTomorrow, addDays 1 now )
    ]
        ++ List.map
            (\days ->
                ( TransDate.humanDayDateMonthFromPosix (addDays days now), addDays days now )
            )
            [ 2, 3, 4, 5, 6 ]


addDays : Int -> Time.Posix -> Time.Posix
addDays days now =
    (days * 24 * 60 * 60 * 1000)
        + Time.posixToMillis now
        |> Time.millisToPosix



-- We might want to move this into theme since it is also used by Partner page


viewEventsList : List Data.PlaceCal.Events.Event -> Html msg
viewEventsList events =
    div []
        [ if List.length events > 0 then
            ul [ css [ eventListStyle ] ]
                (List.map (\event -> viewEvent event) events)

          else
            text (t EventsEmptyText)
        ]


viewEvent : Data.PlaceCal.Events.Event -> Html msg
viewEvent event =
    li [ css [ eventListItemStyle ] ]
        [ a [ css [ eventLinkStyle ], href (TransRoutes.toAbsoluteUrl (Event event.id)) ]
            [ article [ css [ eventStyle ] ]
                [ div [ css [ eventDescriptionStyle ] ]
                    [ h4 [ css [ eventTitleStyle ] ] [ text event.name ]
                    , div []
                        [ p [ css [ eventParagraphStyle ] ]
                            [ time [] [ text (TransDate.humanTimeFromPosix event.startDatetime) ]
                            , span [] [ text " — " ]
                            , time [] [ text (TransDate.humanTimeFromPosix event.endDatetime) ]
                            ]

                        --, p [ css [ eventParagraphStyle ] ] [ text (Data.PlaceCal.Events.realmToString event.realm) ]
                        , p [ css [ eventParagraphStyle ] ] [ text event.location ]
                        , case event.partner.name of
                            Just partnerName ->
                                p [ css [ eventParagraphStyle ] ] [ text ("by " ++ partnerName) ]

                            Nothing ->
                                text ""
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
        ]


viewSubscribe : Html msg
viewSubscribe =
    div
        [ css [ subscribeBoxStyle ] ]
        [ p
            [ css [ subscribeTextStyle ] ]
            [ a [ css [ subscribeLinkStyle ] ] [ text (t EventsSubscribeText) ] ]

        -- [fFf]
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
        [ hover
            [ descendants
                [ typeSelector "a" [ color pink ]
                , typeSelector "h4" [ color pink, borderBottomColor white ]
                , typeSelector "span"
                    [ firstChild [ color pink ]
                    , lastChild [ color white ]
                    ]
                ]
            ]
        , withMediaTabletLandscapeUp [ width (calc (pct 50) minus (rem 2)), margin2 (rem 0) (rem 1) ]
        ]


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
        , transition [ colorTransition ]
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
        , transition [ colorTransition ]
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
        , transition [ colorTransition, borderTransition ]
        , withMediaTabletPortraitUp [ fontSize (rem 1.5), lineHeight (rem 1.877) ]
        ]


eventLinkStyle : Style
eventLinkStyle =
    batch
        [ textDecoration none
        , color white
        , transition [ colorTransition ]
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


paginationButtonListStyle : Style
paginationButtonListStyle =
    batch [ displayFlex ]


paginationButtonListItemStyle : Style
paginationButtonListItemStyle =
    batch []


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
        , margin2 (rem 1.5) (rem 0)
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
