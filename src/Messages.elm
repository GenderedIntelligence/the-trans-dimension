module Messages exposing (Msg(..), SharedMsg(..))

import Path exposing (Path)


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | ToggleMenu
    | SharedMsg SharedMsg


type SharedMsg
    = NoOp
