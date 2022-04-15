module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
    | SiteStrapline
      --- Header
    | HeaderMobileMenuButton
    | HeaderAskButton
    | HeaderAskLink
      --- Site Footer
    | FooterSocial
    | FooterSignupText
    | FooterSignupButton
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
    | EventsSubscribeText
      --- Event Page
    | EventTitle String
    | EventMetaDescription String
    | BackToEventsLinkText
      --- Partners Page
    | PartnersTitle
    | PartnersMetaDescription
    | PartnersIntroSummary
    | PartnersIntroDescription
    | PartnersListEmpty
    | PartnersLinkToPartner
      --- Partner Page
    | PartnerTitle String
    | PartnerMetaDescription String
    | PartnerContactsHeading
    | PartnerAddressHeading
    | PartnerAddressEmptyText
    | PartnerUpcomingEventsText
    | PartnerEventsEmptyText String
    | BackToPartnersLinkText
      --- Join Page
    | JoinTitle
    | JoinMetaDescription
    | JoinSubtitle
    | JoinDescription
    | JoinFormInputNameLabel
    | JoinFormInputEmailLabel
    | JoinFormInputPhoneLabel
    | JoinFormInputAddressLabel
    | JoinFormInputJobLabel
    | JoinFormInputOrgLabel
    | JoinFormCheckboxesLabel
    | JoinFormCheckbox1
    | JoinFormCheckbox2
    | JoinFormInputMessageLabel
    | JoinFormInputMessagePlaceholder
    | JoinFormSubmitButton
      --- News Listing Page
    | NewsTitle
    | NewsEmptyText
    | NewsReadMore
    | NewsDescription
      --- News Single Article Page
    | NewsItemTitle String
    | NewsItemDescription String
    | NewsItemReturnButton
      --- Privacy
    | PrivacyTitle
      --- 404
    | ErrorTitle
    | ErrorMessage
    | ErrorButtonText
