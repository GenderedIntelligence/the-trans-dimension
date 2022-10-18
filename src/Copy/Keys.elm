module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
    | TransDimensionDescription
    | SiteLogoSrc
    | PageMetaTitle String
    | GeeksForSocialChangeHomeUrl
    | GenderedIntelligenceHomeUrl
    | GoogleMapSearchUrl String
    | SeeOnGoogleMapText
      --- Header
    | HeaderMobileMenuButton
    | HeaderAskButton
    | HeaderAskLink
      -- Beta Banner
    | BetaBannerText
    | BetaBannerCloseButtonText
      --- Site Footer
    | FooterSocial
    | FooterInstaLink
    | FooterTwitterLink
    | FooterFacebookLink
    | FooterSignupText
    | FooterSignupEmailPlaceholder
    | FooterSignupButton
    | FooterByLine
    | FooterInfoTitle
    | FooterInfoCharity
    | FooterInfoCompany
    | FooterInfoOffice
    | FooterCreditTitle
    | FooterCredit1Text
    | FooterCredit1Name
    | FooterCredit1Link
    | FooterCredit2Text
    | FooterCredit2Name
    | FooterCredit2Link
    | FooterCredit3Text
    | FooterCredit3Name
    | FooterCredit3Link
    | FooterCopyright
      --- Index Page
    | IndexTitle
    | IndexMetaDescription
    | IndexIntroTitle
    | IndexIntroMessage
    | IndexIntroButtonText
    | IndexFeaturedHeader
    | IndexFeaturedButtonText
    | IndexNewsHeader
    | IndexNewsButtonText
      --- About Page
    | AboutTitle
    | AboutMetaDescription
      --- Events Page
    | EventsTitle
    | EventsMetaDescription
    | EventsSummary
    | EventsSubHeading
    | EventsEmptyTextAll
    | EventsEmptyText
    | EventsFilterLabelToday
    | EventsFilterLabelTomorrow
    | EventsFilterLabelAllPast
    | EventsFilterLabelAllFuture
      --- Event Page
    | EventTitle String
    | EventMetaDescription String String
    | BackToPartnerEventsLinkText (Maybe String)
    | BackToEventsLinkText
    | EventVisitPublisherUrlText (Maybe String)
      --- Partners Page
    | PartnersTitle
    | PartnersMetaDescription
    | PartnersIntroSummary
    | PartnersIntroDescription
    | PartnersListEmpty
      --- Partner Page
    | PartnerTitle String
    | PartnerMetaDescription String String
    | PartnerContactsHeading
    | PartnerAddressHeading
    | PartnerAddressEmptyText
    | PartnerDescriptionText String String
    | PartnerUpcomingEventsText String
    | PartnerEventsEmptyText String
    | BackToPartnersLinkText
      --- Join Us Page
    | JoinUsTitle
    | JoinUsMetaDescription
    | JoinUsSubtitle
    | JoinUsDescription
    | JoinUsFormInputNameLabel
    | JoinUsFormInputEmailLabel
    | JoinUsFormInputPhoneLabel
    | JoinUsFormInputAddressLabel
    | JoinUsFormInputJobLabel
    | JoinUsFormInputOrgLabel
    | JoinUsFormCheckboxesLabel
    | JoinUsFormCheckbox1
    | JoinUsFormCheckbox2
    | JoinUsFormInputMessageLabel
    | JoinUsFormInputMessagePlaceholder
    | JoinUsFormSubmitButton
      --- News Listing Page
    | NewsTitle
    | NewsEmptyText
    | NewsDescription
      --- News Single Article Page
    | NewsItemTitle String
    | NewsItemMetaDescription String String
    | NewsItemReturnButton
    | NewsItemReadMore
      --- Privacy
    | PrivacyTitle
    | PrivacyMetaDescription
      --- 404
    | ErrorTitle
    | ErrorMessage
    | ErrorButtonText
