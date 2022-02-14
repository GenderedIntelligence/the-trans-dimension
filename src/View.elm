module View exposing (View, map, placeholder)

import Html.Styled exposing (Html, div, h1, text)
import Html.Styled.Attributes exposing (css, id)
import Theme


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.Styled.map fn) doc.body
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body =
        [ h1
            [ css [ Theme.pageHeadingStyle ]
            ]
            [ text moduleName ]
        ]
    }
