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
      --- Links
    | BackToPartnersLinkText
      --- Index Page
    | IndexTitle
    | IndexMetaDescription
      --- About Page
    | AboutTitle
    | AboutMetaDescription
      --- Events Page
    | EventsTitle
    | EventsMetaDescription
      --- Event Page
    | EventTitle String
    | EventMetaDescription String
      --- Partners Page
    | PartnersTitle
    | PartnersMetaDescription
    | PartnersIntro
    | PartnersListEmpty
      --- Partner Page
    | PartnerTitle String
    | PartnerMetaDescription String
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
    | NewsListTitle
    | NewsReadMore
    | NewsMetaDescription
      --- News Single Article Page
    | NewsTitle String
      --- Resources Page
    | ResourcesTitle
    | ResourcesMetaDescription
    | ResourcesIntro
    | ResourcesEmptyText
      --- Privacy
    | PrivacyTitle
      --- Terms and Conditions
    | TermsAndConditionsTitle
