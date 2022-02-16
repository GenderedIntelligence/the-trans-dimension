module PageHeader exposing (viewPageHeader)

import Css exposing (Style, batch, color, fontSize, hex, rem)
import Html.Styled exposing (Html, h1, header, text, nav, ul, li, div, a, p)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Attributes exposing (href)



viewPageHeader : String -> Html msg
viewPageHeader pageTitle =
    header []
        [
            viewPageHeaderNavigation ""
            , viewPageHeaderAsk "Donate" "donate.com"
            , viewPageHeaderTitle pageTitle "Strapline"
        ]

viewPageHeaderTitle : String -> String -> Html msg
viewPageHeaderTitle pageTitle strapLine =
    div []
        [ h1 [ css [ titleStyle ] ] [ text pageTitle ]
        , p [] [text strapLine]
        ]

viewPageHeaderNavigation : String -> Html msg
viewPageHeaderNavigation listItems =
    nav []
        [ ul [] 
            [ li [] [text "Item 1"]
            , li [] [text "Item 2"]
            , li [] [text "Item 3"]
            ]
        ]

viewPageHeaderAsk : String -> String -> Html msg
viewPageHeaderAsk copyText linkTo =
    div []
        [ a [href linkTo] [text copyText]
        ]

titleStyle : Style
titleStyle =
    batch
        [ fontSize (rem 2)
        , color (hex "000000")
        ]