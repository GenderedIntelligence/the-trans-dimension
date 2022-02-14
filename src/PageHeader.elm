module PageHeader exposing (..)

import Css exposing (Style, color, fontSize, rem, hex, batch)
import Html.Styled exposing (h1, header, text)
import Html.Styled.Attributes exposing (css)
import View exposing (..)

pageheader : String -> View msg
pageheader moduleName =
    { title = "Header - " ++ moduleName
    , body =
        [ header []
            [ h1 [ css [ titleStyle ] ] [ text "The Trans Dimension" ]
            ]
        ]
    }


titleStyle : Style
titleStyle =
    batch
        [ fontSize (rem 2)
        , color (hex "000000")
        ]
