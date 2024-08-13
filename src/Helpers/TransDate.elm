module Helpers.TransDate exposing
    ( humanDateFromPosix
    , humanDayDateMonthFromPosix
    , humanDayFromPosix
    , humanShortMonthFromPosix
    , humanTimeFromPosix
    , isAfterDate
    , isOnOrBeforeDate
    , isSameDay
    , isoDateStringDecoder
    )

import DateFormat
import Iso8601
import OptimizedDecoder
import Time


defaultPosix : Time.Posix
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
                    -- It would be better if this returned the timezone as well
                    -- and we tracked the timezone around the app instead of
                    -- assuming UTC due to this.
                    case Iso8601.toTime isoString of
                        Err _ ->
                            defaultPosix

                        Ok posix ->
                            posix
            )


convertedIsoDateZone : Time.Zone
convertedIsoDateZone =
    -- Iso8601.toTime normalizes times from timestamps to UTC, so we follow suit
    Time.utc



---------------------
-- Comparison helpers
---------------------


isSameDay : Time.Posix -> Time.Posix -> Bool
isSameDay aDay anotherDay =
    Time.toDay Time.utc aDay
        == Time.toDay Time.utc anotherDay
        && Time.toMonth Time.utc aDay
        == Time.toMonth Time.utc anotherDay
        && Time.toYear Time.utc aDay
        == Time.toYear Time.utc anotherDay


isOnOrBeforeDate : Time.Posix -> Time.Posix -> Bool
isOnOrBeforeDate aDay anotherDay =
    Time.posixToMillis aDay <= Time.posixToMillis anotherDay


isAfterDate : Time.Posix -> Time.Posix -> Bool
isAfterDate aDay anotherDay =
    Time.posixToMillis aDay > Time.posixToMillis anotherDay



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
            convertedIsoDateZone
            timestamp


humanDayDateMonthFromPosix : Time.Posix -> String
humanDayDateMonthFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid day"

    else
        DateFormat.format
            [ DateFormat.dayOfWeekNameAbbreviated
            , DateFormat.text " "
            , DateFormat.dayOfMonthFixed
            , DateFormat.text " "
            , DateFormat.monthNameAbbreviated
            ]
            convertedIsoDateZone
            timestamp


humanDayFromPosix : Time.Posix -> String
humanDayFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid day"

    else
        DateFormat.format
            -- Do we want the ordinal number here? This is plain.
            [ DateFormat.dayOfMonthFixed ]
            convertedIsoDateZone
            timestamp


humanShortMonthFromPosix : Time.Posix -> String
humanShortMonthFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid month"

    else
        DateFormat.format
            [ DateFormat.monthNameAbbreviated ]
            convertedIsoDateZone
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
            convertedIsoDateZone
            timestamp
