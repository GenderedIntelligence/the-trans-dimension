module Page.Events exposing (Data, Model, Msg, addPartnerNamesToEvents, page, view, viewEvents, viewEventsList, viewEventsWithMiniPaginator)

import Browser.Dom
import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, calc, center, color, column, display, displayFlex, em, firstChild, flexDirection, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, hover, important, int, italic, justifyContent, lastChild, letterSpacing, lineHeight, margin, margin2, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, maxWidth, minus, none, paddingBottom, pct, px, rem, row, rowReverse, solid, spaceBetween, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h4, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Shared
import Task
import Theme.Global exposing (borderTransition, colorTransition, introTextLargeStyle, pink, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Theme.Paginator as Paginator exposing (Msg(..))
import Time
import View exposing (View)


type alias Model =
    ViewModel
        { viewportWidth : Float
        }


type alias ViewModel extends =
    { extends
        | filterBy : Paginator.Filter
        , visibleEvents : List Data.PlaceCal.Events.Event
        , nowTime : Time.Posix
    }


type alias Msg =
    Paginator.Msg


type alias RouteParams =
    {}


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( { filterBy = Paginator.None
      , visibleEvents = static.data
      , nowTime = Time.millisToPosix 0
      , viewportWidth = 320
      }
    , Cmd.batch
        [ Task.perform GetTime Time.now
        , Task.perform GotViewport Browser.Dom.getViewport
        ]
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
                | filterBy = Paginator.Day posix
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate static.data posix
              }
            , Cmd.none
            )

        ClickedAllPastEvents ->
            ( { localModel
                | filterBy = Paginator.Past
                , visibleEvents = List.reverse (Data.PlaceCal.Events.onOrBeforeDate static.data localModel.nowTime)
              }
            , Cmd.none
            )

        ClickedAllFutureEvents ->
            ( { localModel
                | filterBy = Paginator.Future
                , visibleEvents = Data.PlaceCal.Events.afterDate static.data localModel.nowTime
              }
            , Cmd.none
            )

        GetTime newTime ->
            ( { localModel
                | filterBy = Paginator.Day newTime
                , nowTime = newTime
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate static.data newTime
              }
            , Cmd.none
            )

        ScrollRight ->
            ( localModel
            , Task.attempt (\_ -> NoOp)
                (Paginator.scrollPagination Paginator.Right localModel.viewportWidth)
            )

        ScrollLeft ->
            ( localModel
            , Task.attempt (\_ -> NoOp)
                (Paginator.scrollPagination Paginator.Left localModel.viewportWidth)
            )

        GotViewport viewport ->
            ( { localModel | viewportWidth = Maybe.withDefault localModel.viewportWidth (Just viewport.scene.width) }, Cmd.none )

        NoOp ->
            ( localModel, Cmd.none )


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
    PageTemplate.pageMetaTags
        { title = EventsTitle
        , description = EventsMetaDescription
        , imageSrc = Nothing
        }


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload (List Data.PlaceCal.Events.Event) RouteParams
    -> View Msg
view maybeUrl sharedModel localModel static =
    { title = t (PageMetaTitle (t EventsTitle))
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = t EventsSummary, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (viewEvents localModel)
            , outerContent = Nothing
            }
        ]
    }


viewEvents :
    ViewModel any
    -> Html Msg
viewEvents viewModel =
    section [ css [ eventsContainerStyle ] ]
        [ Paginator.viewPagination viewModel
        , viewFilteredEventsList viewModel.filterBy viewModel.visibleEvents
        ]

viewEventsWithMiniPaginator : ViewModel any -> Html Msg
viewEventsWithMiniPaginator viewModel =
    section [ css [ eventsContainerStyle ] ]
        [ Paginator.viewMiniPaginator viewModel
        , viewFilteredEventsList viewModel.filterBy viewModel.visibleEvents
        ]


viewEventsList : List Data.PlaceCal.Events.Event -> Html msg
viewEventsList events =
    viewFilteredEventsList Paginator.Unknown events


viewFilteredEventsList : Paginator.Filter -> List Data.PlaceCal.Events.Event -> Html msg
viewFilteredEventsList filter filteredEvents =
    div []
        [ if List.length filteredEvents > 0 then
            ul [ css [ eventListStyle ] ]
                (List.map (\event -> viewEvent event) filteredEvents)

          else
            p [ css [ introTextLargeStyle, color pink, important (maxWidth (px 636)) ] ]
                [ text
                    (case filter of
                        Paginator.Day _ ->
                            t EventsEmptyText

                        _ ->
                            t EventsEmptyTextAll
                    )
                ]
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
                        , case event.location of
                            Just aLocation ->
                                if aLocation.postalCode == "" then
                                    text ""

                                else
                                    p [ css [ eventParagraphStyle ] ] [ text aLocation.postalCode ]

                            Nothing ->
                                text ""
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


eventsContainerStyle : Style
eventsContainerStyle =
    batch
        [ margin2 (rem 1) (rem 0)
        , withMediaTabletPortraitUp [ margin2 (rem 1) (rem 0) ]
        ]


eventListStyle : Style
eventListStyle =
    batch
        [ displayFlex
        , flexDirection column
        , withMediaSmallDesktopUp [ margin2 (rem 2) (rem -1) ]
        , withMediaTabletLandscapeUp [ flexDirection row, flexWrap wrap, margin2 (rem 1) (rem -1) ]
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
