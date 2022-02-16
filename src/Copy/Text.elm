module Copy.Text exposing (t)

import Copy.Keys exposing (Key(..))



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "The Trans Dimension"

        SiteStrapline ->
            "Space and spaces for us"

        --- Site Header
        SiteHeaderAskButton ->
            "Donate"

        --- Site Footer
        SiteFooterSignupText ->
            "Sign up to our email list for updates"

        SiteFooterSignupButton ->
            "Sign up"

        SiteFooterInfoText ->
            "The Trans Dimension, c/o Gendered Intelligence"

        SiteFooterInfoContact ->
            "Address and contact info [cCc]"

        SiteFooterCredit ->
            "Built using PlaceCal"

        --- Site Meta
        IndexPageMetaTitle ->
            "Home"

        IndexPageMetaDescription ->
            "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between Gendered Intelligence and Geeks for Social Change."
