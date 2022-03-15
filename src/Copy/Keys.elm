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
    | IndexResourcesHeading
    | IndexResourcesDescription
    | IndexResourcesButtonText
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
    | EventsSubHeading
      --- Event Page
    | EventTitle String
    | EventMetaDescription String
    | BackToEventsLinkText
      --- Partners Page
    | PartnersTitle
    | PartnersMetaDescription
    | PartnersIntro
    | PartnersListEmpty
    | PartnersLinkToPartner
      --- Partner Page
    | PartnerTitle String
    | PartnerMetaDescription String
    | BackToPartnersLinkText
      --- Join Page
    | JoinTitle
    | JoinMetaDescription
    | JoinDescription
    | JoinFormInputNameLabel
    | JoinFormInputTitleLabel
    | JoinFormInputOrgLabel
    | JoinFormInputContactLabel
    | JoinFormInputMessageLabel
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
      --- Resources Page
    | ResourcesTitle
    | ResourcesMetaDescription
    | ResourcesIntro
    | ResourcesEmptyText
      --- Privacy
    | PrivacyTitle
      --- Terms and Conditions
    | TermsAndConditionsTitle
