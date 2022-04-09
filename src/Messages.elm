module Messages exposing (Msg(..), SharedMsg(..))

import Http
import Path exposing (Path)


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
      -- Header
    | ToggleMenu
      -- Shared
    | SharedMsg SharedMsg


type SharedMsg
    = NoOp
