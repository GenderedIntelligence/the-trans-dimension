module Page.Partners exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, backgroundColor, batch, block, bold, center, color, display, displayFlex, flexWrap, fontWeight, hover, justifyContent, margin, marginBottom, marginTop, none, padding, pct, rem, spaceBetween, textAlign, textDecoration, width, wrap)
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h2, h3, li, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global as Theme exposing (darkBlue, pink, white)
import View exposing (View)
import Css exposing (padding2)
import Css exposing (fontSize)
import Css exposing (lineHeight)
import Css exposing (fontStyle)
import Css exposing (italic)
import Css exposing (margin2)
import Css exposing (int)
import Css exposing (borderRadius)
import Html.Styled exposing (h1)
import Html.Styled exposing (img)
import Html.Styled.Attributes exposing (src)
import Html.Styled.Attributes exposing (alt)
import Theme.Global exposing (withMediaTabletPortraitUp)
import Css exposing (px)
import Css exposing (inline)
import Css exposing (position)
import Css exposing (absolute)
import Css exposing (top)
import Css exposing (relative)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    List Data.PlaceCal.Partners.Partner


data : DataSource (List Data.PlaceCal.Partners.Partner)
data =
    DataSource.map (\sharedData -> sharedData.allPartners) Data.PlaceCal.Partners.partnersData


head :
    StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = t SiteTitle
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t PartnersMetaDescription
        , locale = Nothing
        , title = t PartnersTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t PartnersTitle
    , body =
        [ viewHeader
        , viewIntro
        , viewPartners static
        ]
    }


viewHeader : Html msg
viewHeader =
    section [ css [ headerSectionStyle ]] [ h1 [ css [ headerLogoStyle ]] 
                  [ img [ src "/images/logos/tdd_logo_with_strapline.svg"
                        , alt (t SiteTitle)
                        , css [ headerLogoImageStyle ]
                        ] [] 
                  ]
               , h2 [ css [ Theme.pageHeadingStyle ] ] [ text (t PartnersTitle) ] ]

headerSectionStyle : Style
headerSectionStyle =
    batch
        [ position relative ]
headerLogoStyle : Style
headerLogoStyle =
    batch
        [ display none
        , withMediaTabletPortraitUp
            [ width (pct 100)
            , display block
            , textAlign center
            , position absolute
            , top (px 50)] 
        ]

headerLogoImageStyle : Style
headerLogoImageStyle =
    batch
        [ width (px 268)
        , display inline
        ]

viewIntro : Html msg
viewIntro =
    section [ css [ Theme.introBoxStyle ] ] 
            [ p [ css [ Theme.introTextLargeStyle ] ] [ text (t PartnersIntroSummary) ]
            , p [ css [ Theme.introTextSmallStyle ] ] [ text (t PartnersIntroDescription) ] 
            ]


viewPartners : StaticPayload (List Data.PlaceCal.Partners.Partner) RouteParams -> Html msg
viewPartners static =
    section []
        [ div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Filters" ]
        , if List.length static.data > 0 then
            ul [ css [ listStyle ] ] (List.map (\partner -> viewPartner partner) static.data)

          else
            p [] [ text (t PartnersListEmpty) ]
        , viewMap
        ]


viewPartner : Data.PlaceCal.Partners.Partner -> Html msg
viewPartner partner =
    li [ css [ listItemStyle ] ]
        [ h3 []
            [ text partner.name ]
        , p []
            [ text partner.summary
            , a [ href (TransRoutes.toAbsoluteUrl (Partner partner.id)), css [ readMoreStyle ] ] [ text (t PartnersLinkToPartner) ]
            ]
        ]



viewMap : Html msg
viewMap =
    div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Map" ]

featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , marginBottom (rem 2)
        ]


readMoreStyle : Style
readMoreStyle =
    batch
        [ display block
        , backgroundColor darkBlue
        , color white
        , textDecoration none
        , padding (rem 0.5)
        , marginTop (rem 1)
        , hover [ backgroundColor pink, color darkBlue ]
        ]


listStyle : Style
listStyle =
    batch
        [ displayFlex
        , flexWrap wrap
        , justifyContent spaceBetween
        ]


listItemStyle : Style
listItemStyle =
    batch
        [ margin (rem 1)
        , width (pct 30)
        , textAlign center
        ]
