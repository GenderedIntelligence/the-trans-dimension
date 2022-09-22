module View exposing (View, fontPreload, map, plausibleTracker)

import Html.Styled exposing (Html, node)
import Html.Styled.Attributes exposing (attribute, href, rel, src)


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.Styled.map fn) doc.body
    }


fontPreload : Html msg
fontPreload =
    node "link"
        [ rel "stylesheet preload"
        , href "https://use.typekit.net/rog1plq.css"
        ]
        []


plausibleTracker : Html msg
plausibleTracker =
    node "SCRIPT"
        [ attribute "defer" "defer"
        , attribute "data-domain" "transdimension.uk"
        , src "https://plausible.io/js/plausible.js"
        ]
        []
