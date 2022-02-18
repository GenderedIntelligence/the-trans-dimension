module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
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
