module TransDate exposing (humanDateFromPosix, humanTimeFromPosix)

import DateFormat
import Time


humanDateFromPosix : Time.Posix -> String
humanDateFromPosix timestamp =
    DateFormat.format
        [ DateFormat.dayOfMonthSuffix
        , DateFormat.text " "
        , DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.yearNumber
        ]
        -- Note hardcoded to UTC zone
        Time.utc
        timestamp


humanTimeFromPosix : Time.Posix -> String
humanTimeFromPosix timestamp =
    DateFormat.format
        [ DateFormat.hourNumber
        , DateFormat.text ":"
        , DateFormat.minuteFixed
        , DateFormat.amPmLowercase
        ]
        -- Note hardcoded to UTC zone
        Time.utc
        timestamp
