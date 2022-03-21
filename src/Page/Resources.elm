module Page.Resources exposing (Data, Model, Msg, page, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.Resources
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html, a, div, h2, h3, h4, li, p, section, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global
import Theme.PageTemplate as PageTemplate
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
    List ( String, List Data.Resources.ResourceData )


data : DataSource Data
data =
    DataSource.succeed Data.Resources.resourcesData


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
        , description = t ResourcesMetaDescription
        , locale = Nothing
        , title = t ResourcesTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t ResourcesTitle
    , body =
        [ PageTemplate.view { title = t ResourcesTitle, bigText = t ResourcesIntro, smallText = [] } (viewResources static.data) Nothing
        ]
    }


viewResources : Data -> Html msg
viewResources resourcesList =
    section []
        [ div [] [ text "[fFf] Filters!" ]
        , if List.length resourcesList == 0 then
            p [] [ text (t ResourcesEmptyText) ]

          else
            ul []
                (List.map
                    (\( section, resourceDataList ) ->
                        if List.length resourceDataList == 0 then
                            -- [cCc] Do we want empty state & show all category headings?
                            text ""

                        else
                            viewResource section resourceDataList
                    )
                    resourcesList
                )
        ]


viewResource : String -> List Data.Resources.ResourceData -> Html msg
viewResource category resources =
    li []
        [ h3 [] [ text category ]
        , ul []
            (List.map
                (\resource ->
                    li []
                        [ h4 [] [ text resource.name ]
                        , p [] [ text resource.description ]
                        , a [ href resource.url ] [ text resource.url ]
                        ]
                )
                resources
            )
        ]
