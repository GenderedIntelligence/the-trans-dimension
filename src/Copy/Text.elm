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
        FooterSocial ->
            "Follow us out there"

        FooterSignupText ->
            "Register for updates"

        FooterSignupButton ->
            "Sign up"

        FooterInfoTitle ->
            "The Trans Dimension, c/o Gendered Intelligence [cCc]"

        FooterInfoCharity ->
            "Gendered Intelligence is a Registered Charity in England and Wales No. 1182558."

        FooterInfoCompany ->
            "Registered as a Company Limited by Guarantee in England and Wales No. 06617608."

        FooterInfoOffice ->
            "Registered office at VAI, 200 Pentonville Road, London N1 9JP."

        FooterCreditTitle ->
            "Credits"

        FooterCredit1Text ->
            "Illustrations by"

        FooterCredit1Name ->
            "Harry Woodgate"

        FooterCredit1Link ->
            "link [cCc]"

        FooterCredit2Text ->
            "design by"

        FooterCredit2Name ->
            "Squid"

        FooterCredit2Link ->
            "link [cCc]"

        FooterCredit3Text ->
            "website by"

        FooterCredit3Name ->
            "GFSC"

        FooterCredit3Link ->
            "http://gfsc.studio/"

        FooterCopyright ->
            "© 2022 The Trans Dimension. All rights reserved."

        --- Index Page
        IndexTitle ->
            "Home"

        IndexMetaDescription ->
            "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between Gendered Intelligence and Geeks for Social Change."

        IndexIntroTitle ->
            "Trusted, accessible, trans-friendly spaces. Always expanding."

        IndexIntroMessage ->
            "The Trans Dimension is an online community hub connecting trans communities across the UK. We collate news, events and services by and for trans people."

        IndexIntroButtonText ->
            "See what's on near you"

        IndexResourcesHeading ->
            "Need help?"

        IndexResourcesSubheading ->
            "Check out our resources."

        IndexResourcesDescription ->
            "We've collated a selection of useful links and services both run for and led by trans people."

        IndexResourcesButtonText ->
            "[cCc] Resources"

        IndexFeaturedHeader ->
            "[cCc] Featured Events"

        IndexFeaturedButtonText ->
            "[cCc] More events"

        IndexNewsHeader ->
            "[cCc] Latest update"

        IndexNewsButtonText ->
            "View more news"

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

        EventsSummary ->
            "Events & activities upcoming in your area."

        EventsSubHeading ->
            "[cCc] Upcoming events"

        EventsSubscribeText ->
            "[cCc] Subscribe with iCal / Google Calendar etc"

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

        PartnersIntroSummary ->
            "We are proud to partner with a number of charities and organisations with a long track record of supporting the trans community."

        PartnersIntroDescription ->
            "All of our partners are explicitly trans-friendly organisations. Some are led by trans people, and some led by friends and allies. They put on events, provide services and offer support for members of our community."

        PartnersListEmpty ->
            "[cCc] There are currently no partners"

        PartnersLinkToPartner ->
            "[cCc] Read more"

        --- Partner Page
        PartnerTitle partnerName ->
            "[cCc] PlaceCal Partner - " ++ partnerName

        PartnerMetaDescription partnerName ->
            "[cCc] Partner description for " ++ partnerName

        PartnerContactsHeading ->
            "Get in touch"

        PartnerAddressHeading ->
            "Address"

        PartnerAddressEmptyText ->
            "[cCc] No address provided"

        PartnerEventsEmptyText partnerName ->
            partnerName ++ " does not have any upcoming events [cCc]"

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
            "Updates & articles from The Trans Dimension."

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
