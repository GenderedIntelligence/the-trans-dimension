module View exposing (View, fontPreload, map, placeholder)

import Css.Global exposing (html)
import Html.Styled exposing (Attribute, Html, div, h1, node, text)
import Html.Styled.Attributes exposing (css, href, id, rel)
import Theme.Global


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
            []
            [ text moduleName ]
        ]
    }


fontPreload : Html msg
fontPreload =
    node "link"
        [ rel "stylesheet preload"
        , href "https://use.typekit.net/rog1plq.css"
        ]
        []
