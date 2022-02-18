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
      --- Partners Page
    | PartnersMetaTitle
    | PartnersMetaDescription
    | PartnersIntro
      --- Partner Page
    | PartnerMetaTitle String
    | PartnerMetaDescription String
