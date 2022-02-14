module PageHeader exposing (viewPageHeader)

import Css exposing (Style, batch, color, fontSize, hex, rem)
import Html.Styled exposing (Html, h1, header, text)
import Html.Styled.Attributes exposing (css)
import View exposing (..)


viewPageHeader : String -> Html msg
viewPageHeader pageTitle =
    header []
        [ h1 [ css [ titleStyle ] ] [ text pageTitle ]
        ]


titleStyle : Style
titleStyle =
    batch
        [ fontSize (rem 2)
        , color (hex "000000")
        ]
