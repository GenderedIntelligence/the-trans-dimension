module Page.Index exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, auto, backgroundClip, backgroundColor, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, borderRadius, bottom, calc, center, color, cover, display, fontSize, fontStyle, fontWeight, height, inlineBlock, int, italic, lineHeight, margin, margin2, marginBottom, marginTop, minus, none, nthOfType, padding, padding2, padding4, pct, position, property, px, relative, rem, textAlign, textDecoration, top, url, vh, vw, width, zIndex)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled as Html exposing (Html, a, article, div, h2, h3, li, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import String exposing (left)
import Theme.Global exposing (..)
import View exposing (View)


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


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
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
        , description = t IndexMetaDescription
        , locale = Nothing
        , title = t IndexTitle -- metadata.title
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t SiteTitle
    , body =
        [ div [ css [ pageWrapperStyle ] ]
            [ viewIntro (t IndexIntroTitle) (t IndexIntroMessage) (t IndexIntroButtonText)
            , viewResources (t IndexResourcesHeading) (t IndexResourcesDescription) (t IndexResourcesButtonText)
            , viewFeatured (t IndexFeaturedHeader) (t IndexFeaturedButtonText)
            , viewLatestNews (t IndexNewsHeader) (t IndexNewsButtonText)
            ]
        ]
    }


viewIntro : String -> String -> String -> Html msg
viewIntro introTitle introMsg eventButtonText =
    section [ css [ sectionStyle, introSectionStyle ] ]
        [ h3 [ css [ sectionTitleStyle ] ] [ text introTitle ]
        , p [ css [ sectionTextStyle ] ] [ text introMsg ]
        , a
            [ href (TransRoutes.toAbsoluteUrl Events)
            , css [ buttonStyle ]
            ]
            [ text eventButtonText ]
        ]


viewResources : String -> String -> String -> Html msg
viewResources title description buttonText =
    section [ css [ sectionStyle ] ]
        [ h2 [] [ text title ]
        , p [] [ text description ]
        , a
            [ href (TransRoutes.toAbsoluteUrl Resources)
            , css [ buttonStyle ]
            ]
            [ text buttonText ]
        ]


viewFeatured : String -> String -> Html msg
viewFeatured title buttonText =
    section [ css [ sectionStyle ] ]
        [ h2 [] [ text title ]
        , ul []
            [ li [] [ text "Featured event [fFf]" ]
            , li [] [ text "Featured event [fFf]" ]
            , li [] [ text "Featured event [fFf]" ]
            ]
        , a
            [ href (TransRoutes.toAbsoluteUrl Events)
            , css [ buttonStyle ]
            ]
            [ text buttonText ]
        ]


viewLatestNews : String -> String -> Html msg
viewLatestNews title buttonText =
    section [ css [ sectionStyle ] ]
        [ h2 [] [ text title ]
        , article [] [ text "News item title [fFf]" ]
        , a
            [ href (TransRoutes.toAbsoluteUrl News)
            , css [ buttonStyle ]
            ]
            [ text buttonText ]
        ]


pageWrapperStyle : Style
pageWrapperStyle =
    batch
        [ margin2 (rem 0) (rem 0.75) ]


sectionStyle : Style
sectionStyle =
    batch
        [ backgroundColor pink
        , borderRadius (rem 0.3)
        , padding4 (rem 1) (rem 1) (rem 4) (rem 1)
        , marginBottom (rem 2)
        , position relative
        ]


sectionTitleStyle : Style
sectionTitleStyle =
    batch
        [ padding2 (rem 0.5) (rem 1)
        , marginBottom (rem 1)
        , textAlign center
        , fontStyle italic
        , fontSize (rem 2.1)
        , lineHeight (rem 2.3)
        ]


sectionTextStyle : Style
sectionTextStyle =
    batch
        [ textAlign center
        , color darkBlue
        ]


introSectionStyle : Style
introSectionStyle =
    batch
        [ position relative
        , marginTop (vh 75)
        , before
            [ property "content" "\"\""
            , display block
            , backgroundImage (url "/images/illustrations/320px/homepage_1_header.png")
            , width (vw 100)
            , height (vh 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , margin2 (rem 0) (rem -0.75)
            , position absolute
            , top (vh -93)
            , zIndex (int -1)
            ]
        ]



-- ( px 430, px 626 )


buttonStyle : Style
buttonStyle =
    batch
        [ backgroundColor white
        , color darkBlue
        , textDecoration none
        , padding2 (rem 0.5) (rem 1)
        , margin2 (rem 1) auto
        , display block
        , position absolute
        , bottom (rem -2)
        , borderRadius (rem 0.3)
        , fontWeight (int 700)
        ]
