module Page.Partners exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, a, div, h2, h3, li, p, section, text, ul)
import Html.Styled.Attributes exposing (href)
import Page exposing (Page, PageWithState, StaticPayload)
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


type alias Data =
    List Shared.Partner


data : DataSource (List Shared.Partner)
data =
    DataSource.map (\sharedData -> sharedData.partners) Shared.data


head :
    StaticPayload (List Shared.Partner) RouteParams
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
        , title = t PartnersMetaTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Shared.Partner) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t PartnersMetaTitle
    , body =
        [ viewHeader
        , viewIntro
        , viewPartners static
        ]
    }


viewHeader : Html msg
viewHeader =
    section [] [ h2 [] [ text (t PartnersMetaTitle) ] ]


viewIntro : Html msg
viewIntro =
    section [] [ p [] [ text (t PartnersIntro) ] ]


viewPartners : StaticPayload (List Shared.Partner) RouteParams -> Html msg
viewPartners static =
    section []
        [ div [] [ text "[fFf] Filters" ]
        , if List.length static.data > 0 then
            ul [] (List.map (\partner -> viewPartner partner) static.data)

          else
            p [] [ text (t PartnersListEmpty) ]
        , viewMap
        ]


viewPartner : Shared.Partner -> Html msg
viewPartner partner =
    li []
        [ h3 []
            [ text partner.name
            , p []
                [ text partner.summary
                , a [ href ("/partners/" ++ partner.id) ] [ text "[cCc] Read more" ]
                ]
            ]
        ]


viewMap : Html msg
viewMap =
    div [] [ text "[fFf] Map" ]
