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

        SiteLogoSrc ->
            "/images/logos/tdd_logo_with_strapline_on_darkBlue.png"

        PageMetaTitle pageTitle ->
            String.join " | " [ pageTitle, t SiteTitle ]

        --- Header
        HeaderMobileMenuButton ->
            "Menu"

        HeaderAskButton ->
            "Donate"

        HeaderAskLink ->
            -- Gendered Intelligence just giving page
            "https://localgiving.org/donation/genderedintelligence?emb=3wLf1uws5L"

        --- Footer
        FooterSocial ->
            "Follow us out there"

        FooterSignupText ->
            "Register for updates"

        FooterSignupButton ->
            "Sign up"

        FooterInfoTitle ->
            "The Trans Dimension, c/o Gendered Intelligence"

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
            "https://www.harrywoodgate.com/"

        FooterCredit2Text ->
            "design by"

        FooterCredit2Name ->
            "Squid"

        FooterCredit2Link ->
            "https://studiosquid.co.uk/studio/"

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

        IndexFeaturedHeader ->
            "Featured Events"

        IndexFeaturedButtonText ->
            "View all events"

        IndexNewsHeader ->
            "Latest news"

        IndexNewsButtonText ->
            "View all news"

        -- About Page (NOTE: also comes from md)
        AboutTitle ->
            "About"

        AboutMetaDescription ->
            "The Trans Dimension is an online community hub connecting trans communities across the UK. We collate news, events and services by and for trans people."

        -- Events Page
        EventsTitle ->
            "Events"

        EventsMetaDescription ->
            "Events and activities by and for trans communities across the UK."

        EventsSummary ->
            "Events & activities upcoming"

        EventsSubHeading ->
            "Upcoming events"

        EventsEmptyTextAll ->
            "There are no upcoming events. Check back for updates!"

        EventsEmptyText ->
            "There are no upcoming events on this date. Check back for updates!"

        EventsFilterLabelToday ->
            "Today"

        EventsFilterLabelTomorrow ->
            "Tomorrow"

        EventsFilterLabelAll ->
            "All Events"

        --- Event Page
        EventTitle eventName ->
            "Event - " ++ eventName

        EventMetaDescription eventName eventSummary ->
            eventName ++ " - " ++ eventSummary

        BackToEventsLinkText ->
            "Go to all events"

        --- Partners Page
        PartnersTitle ->
            "Partners"

        PartnersMetaDescription ->
            "Trans Dimension partners form an online community for connecting trans people across the UK by publishing service information, events and news on PlaceCal."

        PartnersIntroSummary ->
            "We are proud to partner with a number of charities and organisations with a long track record of supporting the trans community."

        PartnersIntroDescription ->
            "All of our partners are explicitly trans-friendly organisations. Some are led by trans people, and some led by friends and allies. They put on events, provide services and offer support for members of our community."

        PartnersListEmpty ->
            "There are currently no Trans Dimension partners"

        --- Partner Page
        PartnerTitle partnerName ->
            "PlaceCal Partner - " ++ partnerName

        PartnerMetaDescription partnerName partnerSummary ->
            partnerName ++ " - " ++ partnerSummary

        PartnerContactsHeading ->
            "Get in touch"

        PartnerAddressHeading ->
            "Address"

        PartnerAddressEmptyText ->
            "No address provided"

        PartnerUpcomingEventsText partnerName ->
            "Upcoming events by " ++ partnerName

        PartnerEventsEmptyText partnerName ->
            partnerName ++ " does not have any upcoming events. Check back for updates!"

        BackToPartnersLinkText ->
            "Go to all partners"

        --- Join Page
        JoinTitle ->
            "Join us"

        JoinSubtitle ->
            "Want to be listed on The Trans Dimension?"

        JoinMetaDescription ->
            "Want to be listed on The Trans Dimension? Get in touch and learn how you can create space and spaces for us."

        JoinDescription ->
            "Get in touch and learn how you can create space and spaces for us."

        JoinFormInputNameLabel ->
            "Name"

        JoinFormInputEmailLabel ->
            "Email address"

        JoinFormInputPhoneLabel ->
            "Phone number"

        JoinFormInputJobLabel ->
            "Job title"

        JoinFormInputOrgLabel ->
            "Organisation name"

        JoinFormInputAddressLabel ->
            "Postcode"

        JoinFormCheckboxesLabel ->
            "I'd like:"

        JoinFormCheckbox1 ->
            "A ring back"

        JoinFormCheckbox2 ->
            "More information"

        JoinFormInputMessageLabel ->
            "Your message"

        JoinFormInputMessagePlaceholder ->
            "Enter information about your organisation and events here or any questions you may have!"

        JoinFormSubmitButton ->
            "Submit"

        --- News Listing Page
        NewsTitle ->
            "News"

        NewsEmptyText ->
            "There is no recent news"

        NewsItemReadMore title ->
            "Read the rest of " ++ title

        NewsDescription ->
            "Updates & articles from The Trans Dimension."

        --- News Single Article Page
        NewsItemTitle title ->
            "News -" ++ title

        NewsItemMetaDescription title author ->
            title ++ " - by " ++ author ++ " for The Trans Dimension"

        NewsItemReturnButton ->
            "Go back to news"

        --- Privacy Page (note this also comes from markdown)
        PrivacyTitle ->
            "Privacy"

        PrivacyMetaDescription ->
            "Privacy information for The Trans Dimension website."

        --- 404 Page
        ErrorTitle ->
            "Error 404"

        ErrorMessage ->
            "This page could not be found."

        ErrorButtonText ->
            "Back to home"
