module Page.Partners.Partner_ exposing (Data, Model, Msg, page, view)

import Browser.Dom
import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (isValidUrl, t)
import Css exposing (Style, auto, batch, calc, center, color, display, displayFlex, fontStyle, important, inlineBlock, margin2, margin4, marginBlockEnd, marginBlockStart, marginTop, maxWidth, minus, normal, paddingTop, pct, px, rem, textAlign, width)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, address, div, h3, hr, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, href, id, src, target)
import Page exposing (PageWithState, StaticPayload)
import Page.Events
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Shared
import Task
import Theme.Global exposing (hrStyle, introTextLargeStyle, linkStyle, normalFirstParagraphStyle, pink, smallInlineTitleStyle, viewBackButton, white, withMediaMediumDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Theme.Paginator as Paginator exposing (Msg(..))
import Theme.TransMarkdown
import Time
import View exposing (View)


type alias Model =
    { filterBy : Paginator.Filter
    , visibleEvents : List Data.PlaceCal.Events.Event
    , nowTime : Time.Posix
    , viewportWidth : Float
    , urlFragment : Maybe String
    }


type alias Msg =
    Paginator.Msg


type alias RouteParams =
    { partner : String }


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    let
        urlFragment : Maybe String
        urlFragment =
            Maybe.andThen .fragment maybeUrl

        tasks : List (Cmd Msg)
        tasks =
            [ Task.perform GetTime Time.now
            , Task.perform GotViewport Browser.Dom.getViewport
            ]
    in
    ( { filterBy = Paginator.None
      , visibleEvents = static.data.events
      , nowTime = Time.millisToPosix 0
      , viewportWidth = 320
      , urlFragment = urlFragment
      }
    , Cmd.batch
        (case urlFragment of
            Just fragment ->
                tasks
                    ++ [ Browser.Dom.getElement fragment
                            |> Task.andThen (\element -> Browser.Dom.setViewport 0 element.element.y)
                            |> Task.attempt (\_ -> NoOp)
                       ]

            Nothing ->
                tasks
        )
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
                    Data.PlaceCal.Events.eventsFromDate static.data.events posix
              }
            , Cmd.none
            )

        ClickedAllPastEvents ->
            ( { localModel
                | filterBy = Paginator.Past
                , visibleEvents = List.reverse (Data.PlaceCal.Events.onOrBeforeDate static.data.events localModel.nowTime)
              }
            , Cmd.none
            )

        ClickedAllFutureEvents ->
            ( { localModel
                | filterBy = Paginator.Future
                , visibleEvents = Data.PlaceCal.Events.afterDate static.data.events localModel.nowTime
              }
            , Cmd.none
            )

        GetTime newTime ->
            ( { localModel
                | filterBy = Paginator.Day newTime
                , nowTime = newTime
                , visibleEvents =
                    Data.PlaceCal.Events.eventsFromDate static.data.events newTime
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
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildWithLocalState
            { init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


routes : DataSource (List RouteParams)
routes =
    DataSource.map
        (\partnerData ->
            partnerData.allPartners
                |> List.map (\partner -> { partner = partner.id })
        )
        Data.PlaceCal.Partners.partnersData


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map2
        (\partnerData eventData ->
            -- There probably a better pattern than succeed with empty.
            -- In theory all will succeed since routes mapped from same list.
            { partner =
                Maybe.withDefault Data.PlaceCal.Partners.emptyPartner
                    ((partnerData.allPartners
                        -- Filter for partner with matching id
                        |> List.filter (\partner -> partner.id == routeParams.partner)
                     )
                        -- There should only be one, so take the head
                        |> List.head
                    )
            , events = Data.PlaceCal.Events.eventsFromPartnerId eventData routeParams.partner
            }
        )
        Data.PlaceCal.Partners.partnersData
        (DataSource.map (\eventsData -> eventsData.allEvents) Data.PlaceCal.Events.eventsData)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    PageTemplate.pageMetaTags
        { title = PartnerTitle static.data.partner.name
        , description = PartnerMetaDescription static.data.partner.name static.data.partner.summary
        , imageSrc = Nothing
        }


type alias Data =
    { partner : Data.PlaceCal.Partners.Partner
    , events : List Data.PlaceCal.Events.Event
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel localModel static =
    { title = t (PageMetaTitle static.data.partner.name)
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t PartnersTitle
            , bigText = { text = static.data.partner.name, node = "h3" }
            , smallText = Nothing
            , innerContent =
                Just
                    (viewInfo localModel static.data)
            , outerContent = Just (viewBackButton (TransRoutes.toAbsoluteUrl Partners) (t BackToPartnersLinkText))
            }
        ]
    }


viewInfo : Model -> Data -> Html Msg
viewInfo localModel { partner, events } =
    section [ css [ margin2 (rem 0) (rem 0.35) ] ]
        [ partnerLogo partner.maybeLogo partner.name
        , div [ css [ descriptionStyle ] ] (Theme.TransMarkdown.markdownToHtml (t (PartnerDescriptionText partner.description partner.name)))
        , hr [ css [ hrStyle ] ] []
        , section [ css [ contactWrapperStyle ] ]
            [ div [ css [ contactSectionStyle ] ]
                [ h3 [ css [ contactHeadingStyle, Theme.Global.smallInlineTitleStyle ] ] [ text (t PartnerContactsHeading) ]
                , viewContactDetails partner.maybeUrl partner.contactDetails
                ]
            , div [ css [ contactSectionStyle ] ]
                [ h3 [ css [ contactHeadingStyle, Theme.Global.smallInlineTitleStyle ] ] [ text (t PartnerAddressHeading) ]
                , viewAddress partner.maybeAddress
                ]
            ]
        , hr [ css [ hrStyle ] ] []
        , viewPartnerEvents localModel { partner = partner, events = events }
        , case partner.maybeGeo of
            Just geo ->
                div [ css [ mapContainerStyle ] ]
                    [ p []
                        [ Theme.Global.mapImage
                            (t (MapImageAltText partner.name))
                            { latitude = geo.latitude, longitude = geo.longitude }
                        ]
                    ]

            Nothing ->
                div [ css [ mapContainerStyle ] ] [ text "" ]
        ]


viewPartnerEvents : Model -> Data -> Html Msg
viewPartnerEvents localModel { partner, events } =
    let
        eventAreaTitle =
            h3 [ css [ smallInlineTitleStyle, color white ] ] [ text (t (PartnerUpcomingEventsText partner.name)) ]
    in
    section [ id "events" ]
        (if List.length events > 0 then
            if List.length events > 20 then
                [ eventAreaTitle
                , Page.Events.viewEvents localModel
                ]

            else
                let
                    futureEvents =
                        Data.PlaceCal.Events.afterDate events localModel.nowTime

                    pastEvents =
                        Data.PlaceCal.Events.onOrBeforeDate events localModel.nowTime
                in
                [ if List.length futureEvents > 0 then
                    div []
                        [ eventAreaTitle
                        , Page.Events.viewEventsList futureEvents
                        ]

                  else
                    div [] []
                , if List.length pastEvents > 0 then
                    div []
                        [ h3 [ css [ smallInlineTitleStyle, color white ] ] [ text (t (PartnerPreviousEventsText partner.name)) ]
                        , Page.Events.viewEventsList pastEvents
                        ]

                  else
                    div [] []
                ]

         else
            [ eventAreaTitle
            , p [ css [ introTextLargeStyle, color pink, important (maxWidth (px 636)) ] ] [ text (t (PartnerEventsEmptyText partner.name)) ]
            ]
        )


viewContactDetails : Maybe String -> Data.PlaceCal.Partners.Contact -> Html msg
viewContactDetails maybeUrl contactDetails =
    address []
        [ if String.length contactDetails.telephone > 0 then
            p [ css [ contactItemStyle ] ] [ text contactDetails.telephone ]

          else
            text ""
        , if String.length contactDetails.email > 0 then
            p
                [ css [ contactItemStyle ] ]
                [ a
                    [ href ("mailto:" ++ contactDetails.email)
                    , css [ linkStyle ]
                    ]
                    [ text contactDetails.email
                    ]
                ]

          else
            text ""
        , case maybeUrl of
            Just url ->
                p [ css [ contactItemStyle ] ] [ a [ href url, target "_blank", css [ linkStyle ] ] [ text (Copy.Text.urlToDisplay url) ] ]

            Nothing ->
                text ""
        ]


viewAddress : Maybe Data.PlaceCal.Partners.Address -> Html msg
viewAddress maybeAddress =
    case maybeAddress of
        Just addressFields ->
            address []
                [ div [] (String.split ", " addressFields.streetAddress |> List.map (\line -> p [ css [ contactItemStyle ] ] [ text line ]))
                , p [ css [ contactItemStyle ] ]
                    [ text addressFields.postalCode
                    ]
                , p [ css [ contactItemStyle ] ]
                    [ a [ href (t (GoogleMapSearchUrl addressFields.streetAddress)), css [ linkStyle ], target "_blank" ] [ text (t SeeOnGoogleMapText) ] ]
                ]

        Nothing ->
            p [ css [ contactItemStyle ] ] [ text (t PartnerAddressEmptyText) ]


partnerLogo : Maybe String -> String -> Html msg
partnerLogo maybeLogoUrl partnerName =
    case maybeLogoUrl of
        Just logoUrl ->
            if isValidUrl logoUrl then
                div [ css [ partnerLogoContainer ] ]
                    [ img [ src logoUrl, css [ partnerLogoStyle ], alt (partnerName ++ " logo") ] []
                    , hr [ css [ hrStyle ] ] []
                    ]

            else
                text ""

        Nothing ->
            text ""



---------
-- Styles
---------


descriptionStyle : Style
descriptionStyle =
    batch
        [ normalFirstParagraphStyle
        , withMediaTabletLandscapeUp
            [ margin2 (rem 2) auto
            , maxWidth (px 636)
            ]
        , withMediaTabletPortraitUp
            [ margin2 (rem 2) (rem 2) ]
        ]


contactWrapperStyle : Style
contactWrapperStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex ]
        ]


contactSectionStyle : Style
contactSectionStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 50), marginTop (rem -2) ]
        ]


contactHeadingStyle : Style
contactHeadingStyle =
    batch [ color Theme.Global.pink ]


contactItemStyle : Style
contactItemStyle =
    batch
        [ textAlign center
        , fontStyle normal
        , marginBlockStart (rem 0)
        , marginBlockEnd (rem 0)
        ]


mapContainerStyle : Style
mapContainerStyle =
    batch
        [ margin4 (rem 3) (calc (rem -1.1) minus (px 1)) (calc (rem -0.75) minus (px 1)) (calc (rem -1.1) minus (px 1))
        , withMediaMediumDesktopUp
            [ margin4 (rem 3) (calc (rem -1.85) minus (px 1)) (calc (rem -1.85) minus (px 1)) (calc (rem -1.85) minus (px 1)) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 3) (calc (rem -2.35) minus (px 1)) (px -1) (calc (rem -2.35) minus (px 1)) ]
        ]


partnerLogoContainer : Style
partnerLogoContainer =
    batch
        [ textAlign center
        , paddingTop (rem 2)
        ]


partnerLogoStyle : Style
partnerLogoStyle =
    batch
        [ display inlineBlock
        ]
