module Helpers.TransRoutes exposing (Route(..), toAbsoluteUrl, toPageTitle)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Path


type Route
    = Home
    | About
    | Event String
    | Events
    | Join
    | NewsItem String
    | News
    | Partner String
    | Partners
    | Resources
    | Privacy
    | TermsAndConditions


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

        Join ->
            t JoinTitle

        NewsItem title ->
            t (NewsItemTitle title)

        News ->
            t NewsTitle

        Partner name ->
            t (PartnerTitle name)

        Partners ->
            t PartnersTitle

        Resources ->
            t ResourcesTitle

        Privacy ->
            t PrivacyTitle

        TermsAndConditions ->
            t TermsAndConditionsTitle


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

        Join ->
            Path.fromString "join-us"

        NewsItem slug ->
            Path.join [ "news", slug ]

        News ->
            Path.fromString "news"

        Partner slug ->
            Path.join [ "partners", slug ]

        Partners ->
            Path.fromString "partners"

        Resources ->
            Path.fromString "resources"

        Privacy ->
            Path.fromString "privacy"

        TermsAndConditions ->
            Path.fromString "terms"


toAbsoluteUrl : Route -> String
toAbsoluteUrl route =
    Path.toAbsolute (toPath route)
