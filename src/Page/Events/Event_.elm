module Page.Events.Event_ exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, auto, backgroundColor, batch, block, bold, center, color, display, em, fontSize, fontStyle, fontWeight, hover, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginTop, none, normal, num, padding, pct, rem, textAlign, textDecoration, textTransform, uppercase, width)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners exposing (partnerNamesFromIds)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h2, h3, hr, img, li, main_, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Page.Events exposing (addPartnerNamesToEvents)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (linkStyle, smallInlineTitleStyle)
import Theme.PageTemplate as PageTemplate exposing (HeaderType(..))
import Theme.TransMarkdown
import View exposing (View)
import Css exposing (int)
import Css exposing (letterSpacing)
import Css exposing (px)
import Theme.Global exposing (pink)
import Css exposing (padding4)
import Theme.Global exposing (darkBlue)
import Css exposing (displayFlex)
import Css exposing (borderRadius)
import Html.Styled.Attributes exposing (src)
import Css exposing (justifyContent)
import Css exposing (flexStart)
import Css exposing (marginRight)


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
    DataSource.map2
        (\sharedData partnerData ->
            Maybe.withDefault Data.PlaceCal.Events.emptyEvent
                ((addPartnerNamesToEvents sharedData.allEvents partnerData.allPartners
                    |> List.filter (\event -> event.id == routeParams.event)
                 )
                    |> List.head
                )
        )
        Data.PlaceCal.Events.eventsData
        Data.PlaceCal.Partners.partnersData


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
        [ PageTemplate.view
            { variant = PinkHeader
            , intro =
                { title = t EventsTitle
                , bigText = static.data.name
                , smallText = []
                }
            }
            (Just (viewInfo static.data))
            (Just
                (section []
                    [ Theme.Global.viewBackButton (TransRoutes.toAbsoluteUrl (Partner static.data.partner.id)) "Partner's events"
                    , Theme.Global.viewBackButton (TransRoutes.toAbsoluteUrl Events) (t BackToEventsLinkText)
                    ]
                )
            )
        ]
    }


viewInfo : Data.PlaceCal.Events.Event -> Html msg
viewInfo event =
    section []
        [ div [ css [ dateAndTimeStyle ] ]
            [ p [ css [ dateStyle ] ] [ text (TransDate.humanDateFromPosix event.startDatetime) ]
            , p [ css [ timeStyle ] ] [ text (TransDate.humanTimeFromPosix event.startDatetime), text " - ", text (TransDate.humanTimeFromPosix event.endDatetime) ]
            ]
        , hr [ css [ Theme.Global.hrStyle ] ] []
        , div []
            [ case event.partner.name of
                Just name ->
                    p [ css [ eventPartnerStyle ] ] [ a [ css [ linkStyle ], href (TransRoutes.toAbsoluteUrl (Partner event.partner.id)) ] [ text ("By " ++ name) ] ]

                Nothing ->
                    text ""
            ]

        -- , p [ css [ eventMetaStyle ] ] [ text event.location ]
        -- , p [ css [ eventMetaStyle ] ]
        --    [ text
        --        (Data.PlaceCal.Events.realmToString event.realm)
        --    ]
        , div [ css [ eventDescriptionStyle ] ]
            (Theme.TransMarkdown.markdownToHtml event.description)
        , p [] [ text event.description ]
        , div [ css [ accessibilityBoxStyle ]]
            [ div [ css [ accessibilityIconStyle ] ] [ img [ src "/images/icons/icon_wheelchair.svg"]  [] ]
            , p [ css [ accessibilityTextStyle ] ] [ text "Accessibility information box" ]
            ]
        , hr [ css [ Theme.Global.hrStyle, marginTop (rem 2.5) ] ] []
        , div []
            [ h3 [ css [ color Theme.Global.pink, smallInlineTitleStyle ] ] [ text "Contact Information " ]
            , p [ css [ contactItemStyle ] ] [ text "Phone number" ]
            , p [ css [ contactItemStyle ] ] [ a [ href "/", css [ Theme.Global.linkStyle ] ] [ text "Email address" ] ]
            , p [ css [ contactItemStyle ] ] [ a [ href "/", css [ Theme.Global.linkStyle ] ] [ text "Website address" ] ]
            ]
        , div []
            [ h3 [ css [ color Theme.Global.pink, smallInlineTitleStyle ] ] [ text "Event Address" ]
            , p [ css [ contactItemStyle ] ] [ text "Address info" ]
            ]
        , div [] [ text "[fFf] Map" ]
        ]


eventPartnerStyle : Style
eventPartnerStyle =
    batch
        [ fontSize (rem 1.2)
        , textAlign center
        ]


eventDescriptionStyle : Style
eventDescriptionStyle =
    batch
        [ marginTop (rem 1)
        , marginBottom (rem 2)
        ]

accessibilityBoxStyle : Style
accessibilityBoxStyle =
    batch
        [ padding (rem 1)
        , backgroundColor pink
        , color darkBlue
        , displayFlex
        , borderRadius (rem 0.3)
        , margin2 (rem 2) (rem 0)
        , justifyContent flexStart
        ]

accessibilityIconStyle : Style
accessibilityIconStyle =
    batch
        [ marginTop (rem 0.2)
        , marginRight (rem 1)]

accessibilityTextStyle : Style
accessibilityTextStyle =
    batch
        [ fontSize (rem 0.875)]

contactItemStyle : Style
contactItemStyle =
    batch
        [ textAlign center
        , fontStyle normal
        , marginBlockStart (em 0)
        , marginBlockEnd (em 0)
        ]

dateAndTimeStyle : Style
dateAndTimeStyle =
    batch
        [ margin2 (rem 3) (rem 0)]

dateStyle : Style
dateStyle =
    batch
        [ fontSize (rem 1.8)
        , textAlign center
        , marginBlockEnd (rem 0)
        , textTransform uppercase
        , fontWeight (int 900)
        , marginBottom (rem -0.5)
        ]


timeStyle : Style
timeStyle =
    batch
        [ fontSize (rem 1.2)
        , fontWeight (int 600) 
        , textAlign center
        , textTransform uppercase
        , letterSpacing (px 1.9)
        , color pink
        , marginBlockStart (em 0) ]
