module Theme.TextHeavyPage exposing (view)

import Css exposing (Style, batch, marginBottom, rem)
import Html.Styled exposing (Html, div, h2, section, text)
import Html.Styled.Attributes exposing (css)
import List exposing (concat)
import Theme.Global


view : String -> List (Html msg) -> Html msg
view title body =
    div []
        [ section []
            [ h2 [ css [] ] [ text title ]
            ]
        , section [ css [ bodyStyle ] ] body
        ]


bodyStyle : Style
bodyStyle =
    batch [ marginBottom (rem 2) ]
