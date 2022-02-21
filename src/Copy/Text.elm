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

        --- Header
        HeaderAskButton ->
            "Donate"

        HeaderAskLink ->
            "http://donate.com [cCc]"

        --- Footer
        FooterSignupText ->
            "Sign up to our email list for updates [cCc]"

        FooterSignupButton ->
            "Sign up"

        FooterInfoText ->
            "The Trans Dimension, c/o Gendered Intelligence [cCc]"

        FooterInfoContact ->
            "Address and contact info [cCc]"

        FooterCredit ->
            "Built using PlaceCal [cCc]"

        --- Link Text
        BackToPartnersLinkText ->
            "Go back to partners"

        --- Index Page
        IndexMetaTitle ->
            "Home"

        IndexMetaDescription ->
            "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between Gendered Intelligence and Geeks for Social Change."

        -- Events Page
        EventsMetaTitle ->
            "Events"

        EventsMetaDescription ->
            "[cCc] Events description"

        --- Partners Page
        PartnersMetaTitle ->
            "Partners"

        PartnersMetaDescription ->
            "[cCc] Partners description"

        PartnersIntro ->
            "[cCc] Introduction box / explainer"

        --- Partner Page
        PartnerMetaTitle partnerName ->
            "[cCc] PlaceCal Partner - " ++ partnerName

        PartnerMetaDescription partnerName ->
            "[cCc] Partner description for " ++ partnerName
