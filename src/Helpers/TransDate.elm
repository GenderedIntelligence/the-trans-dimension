module Helpers.TransDate exposing
    ( humanDateFromPosix
    , humanDayFromPosix
    , humanShortMonthFromPosix
    , humanTimeFromPosix
    , isoDateStringDecoder
    )

import DateFormat
import Iso8601
import OptimizedDecoder
import Time


defaultPosix =
    Time.millisToPosix 0



-----------------
-- Decode helpers
-----------------


isoDateStringDecoder : OptimizedDecoder.Decoder Time.Posix
isoDateStringDecoder =
    OptimizedDecoder.string
        |> OptimizedDecoder.andThen
            (\isoString ->
                OptimizedDecoder.succeed <|
                    case Iso8601.toTime isoString of
                        Err err ->
                            defaultPosix

                        Ok posix ->
                            posix
            )



------------------
-- Display helpers
------------------


humanDateFromPosix : Time.Posix -> String
humanDateFromPosix timestamp =
    -- We might want to change this to a Maybe in decoder
    -- For now - render a placeholder if value is the default
    if timestamp == defaultPosix then
        "Invalid date"

    else
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


humanDayFromPosix : Time.Posix -> String
humanDayFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid day"

    else
        DateFormat.format
            -- Do we want the ordinal number here? This is plain.
            [ DateFormat.dayOfMonthFixed ]
            -- Note hardcoded to UTC zone
            Time.utc
            timestamp


humanShortMonthFromPosix : Time.Posix -> String
humanShortMonthFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid month"

    else
        DateFormat.format
            [ DateFormat.monthNameAbbreviated ]
            -- Note hardcoded to UTC zone
            Time.utc
            timestamp


humanTimeFromPosix : Time.Posix -> String
humanTimeFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid time"

    else
        DateFormat.format
            [ DateFormat.hourNumber
            , DateFormat.text ":"
            , DateFormat.minuteFixed
            , DateFormat.amPmLowercase
            ]
            -- Note hardcoded to UTC zone
            Time.utc
            timestamp
