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
        HeaderMobileMenuButton ->
            "Menu"

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

        --- Index Page
        IndexTitle ->
            "Home"

        IndexMetaDescription ->
            "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between Gendered Intelligence and Geeks for Social Change."

        IndexIntroTitle ->
            "Trusted, accessible, trans-friendly spaces. Always expanding."

        IndexIntroMessage ->
            "The Trans Dimension is an online community hub connecting trans* communities across the UK. We collate news, events and services by and for trans people."

        IndexIntroButtonText ->
            "[cCc] Check out our events"

        IndexResourcesHeading ->
            "[cCc] Need help?"

        IndexResourcesDescription ->
            "[cCc] Short description of this section"

        IndexResourcesButtonText ->
            "[cCc] Resources"

        IndexFeaturedHeader ->
            "[cCc] Featured Events"

        IndexFeaturedButtonText ->
            "[cCc] More events"

        IndexNewsHeader ->
            "[cCc] Latest update"

        IndexNewsButtonText ->
            "[cCc] More news"

        -- About Page (NOTE: also comes from md)
        AboutTitle ->
            "About"

        AboutMetaDescription ->
            "[cCc] About description"

        -- Events Page
        EventsTitle ->
            "Events"

        EventsMetaDescription ->
            "[cCc] Events description"

        EventsSubHeading ->
            "[cCc] Upcoming events"

        --- Event Page
        EventTitle eventName ->
            "[cCc] Event - " ++ eventName

        EventMetaDescription eventName ->
            "[cCc] Event description for " ++ eventName

        BackToEventsLinkText ->
            "Go to all events"

        --- Partners Page
        PartnersTitle ->
            "Partners"

        PartnersMetaDescription ->
            "[cCc] Partners description"

        PartnersIntro ->
            "[cCc] Introduction box / explainer"

        PartnersListEmpty ->
            "[cCc] There are currently no partners"

        PartnersLinkToPartner ->
            "[cCc] Read more"

        --- Partner Page
        PartnerTitle partnerName ->
            "[cCc] PlaceCal Partner - " ++ partnerName

        PartnerMetaDescription partnerName ->
            "[cCc] Partner description for " ++ partnerName

        BackToPartnersLinkText ->
            "Go to all partners"

        --- Join Page
        JoinTitle ->
            "[cCc] Join Us"

        JoinMetaDescription ->
            "[cCc] Join The Trans Dimension as a partner"

        JoinDescription ->
            "[cCc] This is why you should join as a Trans Dimension partner and this is how it works and this is what you do. Fill out our form below etc."

        --- News Listing Page
        NewsTitle ->
            "News"

        NewsEmptyText ->
            "[cCc] Sorry, we don't have any news"

        NewsReadMore ->
            "[cCc] Read more"

        NewsDescription ->
            "[cCc] News listing for The Trans Dimension"

        --- News Single Article Page
        NewsItemTitle title ->
            "[cCc] News -" ++ title

        NewsItemDescription author ->
            "[cCc] A news post by" ++ author ++ "for The Trans Dimension"

        NewsItemReturnButton ->
            "Go back to news"

        -- Resources Page
        ResourcesTitle ->
            "Resources"

        ResourcesMetaDescription ->
            "[cCc] Resources meta description"

        ResourcesIntro ->
            "[cCc] Resources page introduction"

        ResourcesEmptyText ->
            "[cCc] No resources"

        -- Join Form
        JoinFormInputNameLabel ->
            "Name"

        JoinFormInputTitleLabel ->
            "Title"

        JoinFormInputOrgLabel ->
            "Organisation"

        JoinFormInputContactLabel ->
            "Contact details"

        JoinFormInputMessageLabel ->
            "Message"

        JoinFormSubmitButton ->
            "Submit"

        --- Privacy Page (note this also comes from markdown)
        PrivacyTitle ->
            "Privacy"

        --- Terms and Conditions Page (note also comes from markdown)
        TermsAndConditionsTitle ->
            "Terms and Conditions"
