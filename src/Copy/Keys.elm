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
      --- News Listing Page
    | NewsTitle
    | NewsReadMore
    | NewsMetaTitle
    | NewsMetaDescription
