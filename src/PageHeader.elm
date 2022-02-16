module PageHeader exposing (viewPageHeader)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, batch, color, fontSize, hex, rem)
import Html.Styled exposing (Html, a, div, h1, header, li, nav, p, text, ul)
import Html.Styled.Attributes exposing (css, href)


viewPageHeader : Html msg
viewPageHeader =
    header []
        [ viewPageHeaderNavigation ""
        , viewPageHeaderAsk "Donate" "donate.com"
        , viewPageHeaderTitle (t SiteTitle) "Strapline"
        ]


viewPageHeaderTitle : String -> String -> Html msg
viewPageHeaderTitle pageTitle strapLine =
    div []
        [ h1 [ css [ titleStyle ] ] [ text pageTitle ]
        , p [] [ text strapLine ]
        ]


viewPageHeaderNavigation : String -> Html msg
viewPageHeaderNavigation listItems =
    nav []
        [ ul []
            [ li [] [ text "Item 1" ]
            , li [] [ text "Item 2" ]
            , li [] [ text "Item 3" ]
            ]
        ]


viewPageHeaderAsk : String -> String -> Html msg
viewPageHeaderAsk copyText linkTo =
    div []
        [ a [ href linkTo ] [ text copyText ]
        ]


titleStyle : Style
titleStyle =
    batch
        [ fontSize (rem 2)
        , color (hex "000000")
        ]
