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
      --- Partners Page
    | PartnersMetaTitle
    | PartnersMetaDescription
    | PartnersIntro
    | PartnersListEmpty
      --- Partner Page
    | PartnerMetaTitle String
    | PartnerMetaDescription String
