module TextHeavyPage exposing (..)

import Html.Styled exposing (Html, div, h2, section, text)


view : String -> String -> Html msg
view title body =
    div []
        [ section []
            [ h2 [] [ text title ]
            ]
        , section [] [ text body ]
        ]
