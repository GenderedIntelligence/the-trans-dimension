module Page.Index exposing (Data, Model, Msg, page)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, a, article, h2, li, p, section, text, ul)
import Html.Styled.Attributes exposing (href)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
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
        , siteName = "elm-pages"
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
        [ viewIntro "Key introductory message" "Check out our events"
        , viewResources "Need help?" "Short description of this section" "Resources"
        , viewFeatured "Featured Events" "More events"
        , viewLatestNews "Latest update" "More news"
        ]
    }


viewIntro : String -> String -> Html msg
viewIntro introMsg eventButtonText =
    section []
        [ p [] [ text introMsg ]
        , a [ href "/events" ] [ text eventButtonText ]
        ]


viewResources : String -> String -> String -> Html msg
viewResources title description buttonText =
    section []
        [ h2 [] [ text title ]
        , p [] [ text description ]
        , a [ href "/resources" ] [ text buttonText ]
        ]


viewFeatured : String -> String -> Html msg
viewFeatured title buttonText =
    section []
        [ h2 [] [ text title ]
        , ul []
            [ li [] [ text "Featured event [fFf]" ]
            , li [] [ text "Featured event [fFf]" ]
            , li [] [ text "Featured event [fFf]" ]
            ]
        , a [ href "/events" ] [ text buttonText ]
        ]


viewLatestNews : String -> String -> Html msg
viewLatestNews title buttonText =
    section []
        [ h2 [] [ text title ]
        , article [] [ text "News item title [fFf]" ]
        , a [ href "/news" ] [ text buttonText ]
        ]
