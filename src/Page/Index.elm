module Page.Index exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, auto, backgroundColor, batch, center, color, display, fontSize, inlineBlock, margin, margin2, none, nthOfType, padding, padding2, pct, rem, textAlign, textDecoration, width)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled as Html exposing (Html, a, article, h2, li, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
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
        [ viewIntro (t IndexIntroMessage) (t IndexIntroButtonText)
        , viewResources (t IndexResourcesHeading) (t IndexResourcesDescription) (t IndexResourcesButtonText)
        , viewFeatured (t IndexFeaturedHeader) (t IndexFeaturedButtonText)
        , viewLatestNews (t IndexNewsHeader) (t IndexNewsButtonText)
        ]
    }


viewIntro : String -> String -> Html msg
viewIntro introMsg eventButtonText =
    section [ css [ sectionStyle ] ]
        [ p [ css [ introMessageStyle ] ] [ text introMsg ]
        , a
            [ href (TransRoutes.toAbsoluteUrl Events)
            , css [ buttonStyle ]
            ]
            [ text eventButtonText ]
        ]


viewResources : String -> String -> String -> Html msg
viewResources title description buttonText =
    section [ css [ sectionStyle ] ]
        [ h2 [ css [ sectionHeaderStyle ] ] [ text title ]
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
        [ h2 [ css [ sectionHeaderStyle ] ] [ text title ]
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
        [ h2 [ css [ sectionHeaderStyle ] ] [ text title ]
        , article [] [ text "News item title [fFf]" ]
        , a
            [ href (TransRoutes.toAbsoluteUrl News)
            , css [ buttonStyle ]
            ]
            [ text buttonText ]
        ]


sectionStyle : Style
sectionStyle =
    batch
        [ textAlign center
        , nthOfType "odd" [ batch [ backgroundColor pink ] ]
        , nthOfType "even" [ batch [ backgroundColor blue ] ]
        , padding (rem 1)
        , width (pct 60)
        , margin2 (rem 2) auto
        ]


sectionHeaderStyle : Style
sectionHeaderStyle =
    batch
        [ color darkBlue
        , fontSize (rem 2)
        ]


introMessageStyle : Style
introMessageStyle =
    batch
        [ fontSize (rem 1.5) ]


buttonStyle : Style
buttonStyle =
    batch
        [ backgroundColor darkBlue
        , color white
        , textDecoration none
        , padding2 (rem 1) (rem 2)
        , margin (rem 1)
        , display inlineBlock
        ]
