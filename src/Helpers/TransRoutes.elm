module Helpers.TransRoutes exposing (Route(..), stringToSlug, toAbsoluteUrl, toPageTitle)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Path
import Slug


type Route
    = Home
    | About
    | Event String
    | Events
    | JoinUs
    | NewsItem String
    | News
    | Donate
    | Partner String
    | Partners
    | Privacy
    | Error


toPageTitle : Route -> String
toPageTitle route =
    case route of
        Home ->
            t IndexTitle

        About ->
            t AboutTitle

        Events ->
            t EventsTitle

        Event name ->
            t (EventTitle name)

        JoinUs ->
            t JoinUsTitle

        NewsItem title ->
            t (NewsItemTitle title)

        News ->
            t NewsTitle

        Donate ->
            t HeaderAskButton

        Partner name ->
            t (PartnerTitle name)

        Partners ->
            t PartnersTitle

        Privacy ->
            t PrivacyTitle

        Error ->
            t ErrorTitle


toPath : Route -> Path.Path
toPath route =
    case route of
        Home ->
            Path.fromString "/"

        About ->
            Path.fromString "about"

        Events ->
            Path.fromString "events"

        Event slug ->
            Path.join [ "events", slug ]

        JoinUs ->
            Path.fromString "join-us"

        NewsItem slug ->
            Path.join [ "news", slug ]

        News ->
            Path.fromString "news"

        Donate ->
            Path.fromString "donate"

        Partner slug ->
            Path.join [ "partners", slug ]

        Partners ->
            Path.fromString "partners"

        Privacy ->
            Path.fromString "privacy"

        Error ->
            Path.fromString "404"


toAbsoluteUrl : Route -> String
toAbsoluteUrl route =
    Path.toAbsolute (toPath route)


stringToSlug : String -> String
stringToSlug stringToSluggify =
    -- Currently nothing done to make sure these are unique
    Slug.generate stringToSluggify
        |> stringFromMaybeSlug


stringFromMaybeSlug : Maybe Slug.Slug -> String
stringFromMaybeSlug maybeSlug =
    case maybeSlug of
        Just slug ->
            Slug.toString slug

        Nothing ->
            "unsluggable"
