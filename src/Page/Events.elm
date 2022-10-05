module Page.Events exposing (Data, Filter(..), Model, Msg, addPartnerNamesToEvents, page, view, viewFutureEventsList)

import Browser.Dom exposing (Viewport)
import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, active, alignItems, auto, backgroundColor, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, calc, center, color, column, cursor, deg, display, displayFlex, em, firstChild, fitContent, flexDirection, flexGrow, flexWrap, focus, fontSize, fontStyle, fontWeight, height, hover, important, int, italic, justifyContent, lastChild, letterSpacing, lineHeight, listStyleType, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, maxWidth, minus, noWrap, none, overflowX, padding2, padding4, paddingBottom, paddingLeft, paddingRight, pct, pointer, position, property, pseudoElement, px, relative, rem, rotate, row, rowReverse, scroll, solid, spaceBetween, textAlign, textDecoration, textTransform, transform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, button, div, h4, img, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href, id, src)
import Html.Styled.Events
import Page exposing (PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Shared
import Task
import Theme.Global exposing (backgroundColorTransition, borderTransition, colorTransition, darkBlue, darkPurple, introTextLargeStyle, pink, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Theme.Paginator as Paginator
import Time
import View exposing (View)


type alias Model =
    { filterBy : Filter
    , visibleEvents : List Data.PlaceCal.Events.Event
    , nowTime : Time.Posix
    , viewportWidth : Float
    }


type Filter
    = Day Time.Posix
    | Past
    | Future


type Msg
    = ClickedDay Time.Posix
    | ClickedAllPastEvents
    | ClickedAllFutureEvents
    | GetTime Time.Posix
    | GotViewport Viewport
    | ScrollRight
    | ScrollLeft
    | NoOp


type alias RouteParams =
    {}


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( { filterBy = Future
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
                | filterBy = Day posix
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate static.data posix
              }
            , Cmd.none
            )

        ClickedAllPastEvents ->
            ( { localModel
                | filterBy = Past
                , visibleEvents = List.reverse (Data.PlaceCal.Events.onOrBeforeDate static.data localModel.nowTime)
              }
            , Cmd.none
            )

        ClickedAllFutureEvents ->
            ( { localModel
                | filterBy = Future
                , visibleEvents = Data.PlaceCal.Events.afterDate static.data localModel.nowTime
              }
            , Cmd.none
            )

        GetTime newTime ->
            ( { localModel
                | filterBy = Day newTime
                , nowTime = newTime
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate static.data newTime
              }
            , Cmd.none
            )

        ScrollRight ->
            ( localModel
            , Task.attempt (\_ -> NoOp)
                (Paginator.scrollPagination
                    (if localModel.viewportWidth < Theme.Global.maxMobile then
                        buttonWidthMobile + (buttonMarginMobile * 2)

                     else if localModel.viewportWidth < Theme.Global.maxTabletPortrait then
                        buttonWidthTablet + (buttonMarginTablet * 2)

                     else
                        buttonWidthFullWidth + (buttonMarginFullWidth * 2)
                    )
                )
            )

        ScrollLeft ->
            ( localModel
            , Task.attempt (\_ -> NoOp)
                (Paginator.scrollPagination
                    (if localModel.viewportWidth < Theme.Global.maxMobile then
                        -(buttonWidthMobile + (buttonMarginMobile * 2))

                     else if localModel.viewportWidth < Theme.Global.maxTabletPortrait then
                        -(buttonWidthTablet + (buttonMarginTablet * 2))

                     else
                        -(buttonWidthFullWidth + (buttonMarginFullWidth * 2))
                    )
                )
            )

        GotViewport viewport ->
            ( { localModel | viewportWidth = Maybe.withDefault localModel.viewportWidth (Just viewport.scene.width) }, Cmd.none )

        NoOp ->
            ( localModel, Cmd.none )


numberOfButtons : Float
numberOfButtons =
    7


buttonWidthMobile : Float
buttonWidthMobile =
    100


buttonMarginMobile : Float
buttonMarginMobile =
    4


buttonWidthTablet : Float
buttonWidthTablet =
    110


buttonMarginTablet : Float
buttonMarginTablet =
    6


buttonWidthFullWidth : Float
buttonWidthFullWidth =
    130


buttonMarginFullWidth : Float
buttonMarginFullWidth =
    8


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
    Model
    -> Html Msg
viewEvents localModel =
    section [ css [ eventsContainerStyle ] ]
        [ viewPagination localModel
        , viewEventsList localModel.filterBy localModel.visibleEvents
        ]


viewPagination : Model -> Html Msg
viewPagination localModel =
    div [ css [ paginationWrapper ] ]
        [ div [ css [ paginationContainer ] ]
            [ button [ css [ paginationArrowButtonStyle ], Html.Styled.Events.onClick ScrollLeft ] [ img [ src "/images/icons/leftarrow.svg", css [ paginationArrowStyle ] ] [] ]
            , div [ css [ paginationScrollableBoxStyle ], id "scrollable" ]
                [ ul [ css [ paginationButtonListStyle ] ]
                    (List.map
                        (\( label, buttonTime ) ->
                            li [ css [ paginationButtonListItemStyle ] ]
                                [ button
                                    [ css
                                        [ case localModel.filterBy of
                                            Day day ->
                                                if TransDate.isSameDay buttonTime day then
                                                    paginationButtonListItemButtonActiveStyle

                                                else
                                                    paginationButtonListItemButtonStyle

                                            _ ->
                                                paginationButtonListItemButtonStyle
                                        ]
                                    , Html.Styled.Events.onClick (ClickedDay buttonTime)
                                    ]
                                    [ text label ]
                                ]
                        )
                        (todayTomorrowNext5DaysPosix localModel.nowTime)
                    )
                ]
            , button [ css [ paginationArrowButtonRightStyle ], id "arrow-right", Html.Styled.Events.onClick ScrollRight ] [ img [ src "/images/icons/rightarrow.svg", css [ paginationRightArrowStyle ] ] [] ]
            ]
        , div [ css [ paginationContainer ] ]
            [ ul [ css [ allEventsButtonListStyle ] ]
                [ li [ css [ allEventsButtonListItemStyle ] ]
                    [ button
                        [ css
                            (if localModel.filterBy == Past then
                                [ important (width (px 200)), paginationButtonListItemButtonActiveStyle ]

                             else
                                [ important (width (px 200)), paginationButtonListItemButtonStyle ]
                            )
                        , Html.Styled.Events.onClick ClickedAllPastEvents
                        ]
                        [ text (t EventsFilterLabelAllPast) ]
                    ]
                , li [ css [ allEventsButtonListItemStyle ] ]
                    [ button
                        [ css
                            (if localModel.filterBy == Future then
                                [ important (width (px 200)), paginationButtonListItemButtonActiveStyle ]

                             else
                                [ important (width (px 200)), paginationButtonListItemButtonStyle ]
                            )
                        , Html.Styled.Events.onClick ClickedAllFutureEvents
                        ]
                        [ text (t EventsFilterLabelAllFuture) ]
                    ]
                ]
            ]
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


viewFutureEventsList : List Data.PlaceCal.Events.Event -> Html msg
viewFutureEventsList events =
    viewEventsList Future events


viewEventsList : Filter -> List Data.PlaceCal.Events.Event -> Html msg
viewEventsList filter events =
    div []
        [ if List.length events > 0 then
            ul [ css [ eventListStyle ] ]
                (List.map (\event -> viewEvent event) events)

          else
            p [ css [ introTextLargeStyle, color pink, important (maxWidth (px 636)) ] ]
                [ text
                    (case filter of
                        Day _ ->
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


paginationWrapper : Style
paginationWrapper =
    batch
        [ margin2 (rem 0) (rem -0.5)
        , withMediaSmallDesktopUp [ margin4 (rem 2) (rem -1) (rem 3) (rem -1) ]
        , withMediaTabletLandscapeUp [ margin2 (rem 2) (rem -1) ]
        ]


paginationContainer : Style
paginationContainer =
    batch
        [ displayFlex
        , maxWidth fitContent
        , margin4 (rem 0) auto (rem 0.5) auto
        , withMediaSmallDesktopUp [ margin2 (rem 0) auto ]
        , withMediaTabletLandscapeUp [ margin2 (rem 0) auto ]
        ]


paginationScrollableBoxStyle : Style
paginationScrollableBoxStyle =
    batch
        [ width (px (buttonWidthMobile * 2 + buttonMarginMobile * 4))
        , position relative
        , overflowX scroll
        , pseudoElement "-webkit-scrollbar" [ display none ]
        , property "-ms-overflow-style" "none"
        , property "scrollbar-width" "none"
        , property "scroll-behaviour" "smooth"
        , withMediaSmallDesktopUp [ width (pct 100) ]
        , withMediaTabletLandscapeUp [ width (px (buttonWidthFullWidth * 5 + buttonMarginFullWidth * 10)) ]
        , withMediaTabletPortraitUp [ width (px (buttonWidthTablet * 4 + buttonMarginTablet * 8)) ]
        ]


paginationButtonStyle : Style
paginationButtonStyle =
    batch
        [ borderStyle solid
        , borderColor pink
        , borderWidth (px 2)
        , color pink
        , borderRadius (rem 0.3)
        , textAlign center
        , cursor pointer
        , hover
            [ backgroundColor darkPurple
            , color white
            , borderColor white
            , descendants [ typeSelector "img" [ property "filter" "invert(1)" ] ]
            ]
        , focus
            [ backgroundColor white
            , color darkBlue
            , borderColor white
            , descendants [ typeSelector "img" [ property "filter" "invert(0)" ] ]
            ]
        , active
            [ backgroundColor white
            , color darkBlue
            , borderColor white
            , descendants [ typeSelector "img" [ property "filter" "invert(0)" ] ]
            ]
        , transition [ colorTransition, borderTransition, backgroundColorTransition ]
        ]


paginationArrowButtonStyle : Style
paginationArrowButtonStyle =
    batch
        [ paginationButtonStyle
        , backgroundColor pink
        , margin4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0)
        , paddingRight (rem 0.5)
        , withMediaSmallDesktopUp [ display none ]
        , withMediaTabletLandscapeUp
            [ padding2 (rem 0) (rem 0.5), margin2 (rem 0.25) (rem 0.75) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 0.25) (rem 0.5) (rem 0.25) (rem 0) ]
        ]


paginationArrowButtonRightStyle : Style
paginationArrowButtonRightStyle =
    batch
        [ paginationButtonStyle
        , backgroundColor pink
        , margin4 (rem 0.25) (rem 0) (rem 0.25) (rem 0.25)
        , paddingLeft (rem 0.5)
        , withMediaSmallDesktopUp [ display none ]
        , withMediaTabletLandscapeUp
            [ padding2 (rem 0) (rem 0.5), margin2 (rem 0.25) (rem 0.75) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 0.25) (rem 0) (rem 0.25) (rem 0.5) ]
        ]


paginationArrowStyle : Style
paginationArrowStyle =
    batch
        [ width (px 13)
        , height (px 11)
        , withMediaTabletPortraitUp [ width (px 18), height (px 15) ]
        ]


paginationRightArrowStyle : Style
paginationRightArrowStyle =
    batch
        [ paginationArrowStyle
        , transform (rotate (deg 180))
        ]


buttonListStyle : Style
buttonListStyle =
    batch
        [ displayFlex
        , justifyContent center
        , boxSizing borderBox
        , position relative
        , width (px (buttonWidthMobile * numberOfButtons + buttonMarginMobile * (numberOfButtons * 2)))
        , withMediaTabletLandscapeUp
            [ width (px (buttonWidthFullWidth * numberOfButtons + buttonMarginFullWidth * (numberOfButtons * 2))) ]
        , withMediaTabletPortraitUp
            [ width (px (buttonWidthTablet * numberOfButtons + buttonMarginTablet * (numberOfButtons * 2))) ]
        ]


paginationButtonListStyle : Style
paginationButtonListStyle =
    batch
        [ buttonListStyle
        , flexWrap noWrap
        ]


allEventsButtonListStyle : Style
allEventsButtonListStyle =
    batch
        [ buttonListStyle
        , flexWrap wrap
        ]


paginationButtonListItemStyle : Style
paginationButtonListItemStyle =
    batch
        [ margin2 (rem 0.25) (px buttonMarginMobile)
        , listStyleType none
        , withMediaTabletLandscapeUp [ margin2 (rem 0.25) (rem 0.5) ]
        , withMediaTabletPortraitUp [ margin2 (rem 0.25) (rem 0.375) ]
        ]


allEventsButtonListItemStyle : Style
allEventsButtonListItemStyle =
    batch
        [ listStyleType none
        , textAlign center
        , margin (rem 0.5)
        ]


paginationButtonListItemButtonStyle : Style
paginationButtonListItemButtonStyle =
    batch
        [ paginationButtonStyle
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , padding4 (rem 0.2) (rem 0.2) (rem 0.3) (rem 0.2)
        , width (px buttonWidthMobile)
        , backgroundColor darkBlue
        , withMediaTabletLandscapeUp [ width (px buttonWidthFullWidth), fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ width (px buttonWidthTablet), fontSize (rem 1) ]
        ]


paginationButtonListItemButtonActiveStyle : Style
paginationButtonListItemButtonActiveStyle =
    batch
        [ paginationButtonStyle
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , padding4 (rem 0.2) (rem 0.2) (rem 0.3) (rem 0.2)
        , width (px buttonWidthMobile)
        , backgroundColor pink
        , color darkBlue
        , withMediaTabletLandscapeUp [ width (px buttonWidthFullWidth), fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ width (px buttonWidthTablet), fontSize (rem 1) ]
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , backgroundColor darkPurple
        ]
