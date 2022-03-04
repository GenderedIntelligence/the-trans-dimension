module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
    | SiteStrapline
      --- Header
    | HeaderAskButton
    | HeaderAskLink
      --- Site Footer
    | FooterSignupText
    | FooterSignupButton
    | FooterInfoText
    | FooterInfoContact
    | FooterCredit
      --- Index Page
    | IndexTitle
    | IndexMetaDescription
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
