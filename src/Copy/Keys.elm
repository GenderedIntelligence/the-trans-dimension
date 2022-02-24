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
    | IndexMetaTitle
    | IndexMetaDescription
      --- About Page
    | AboutMetaTitle
    | AboutMetaDescription
      --- Events Page
    | EventsMetaTitle
    | EventsMetaDescription
      --- Event Page
    | EventMetaTitle String
    | EventMetaDescription String
      --- Partners Page
    | PartnersMetaTitle
    | PartnersMetaDescription
    | PartnersIntro
    | PartnersListEmpty
      --- Partner Page
    | PartnerMetaTitle String
    | PartnerMetaDescription String
      --- Join Page
    | JoinMetaTitle
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
    | NewsReadMore
    | NewsMetaTitle
    | NewsMetaDescription
