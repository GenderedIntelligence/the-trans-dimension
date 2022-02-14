module Copy.Text exposing (t)

import Copy.Keys exposing (Key(..))



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "The Trans Dimension"

        --- Site Meta
        IndexMetaTitle ->
            "Home"

        IndexMetaDescription ->
            "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between Gendered Intelligence and Geeks for Social Change."

        PartnersMetaTitle ->
            "Partners"

        PartnersMetaDescription ->
            "[cCc] Partners description"

        --- Page content
        PartnersIntro ->
            "[cCc] Introduction box / explainer"
