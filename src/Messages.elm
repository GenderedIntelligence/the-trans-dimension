module Messages exposing (Msg(..), SharedMsg(..))

import Path exposing (Path)
import Time


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | GetTime Time.Posix
      -- Header
    | ToggleMenu
    | HideBetaBanner
      -- Shared
    | SharedMsg SharedMsg


type SharedMsg
    = NoOp
