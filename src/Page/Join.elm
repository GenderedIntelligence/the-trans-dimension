module Page.Join exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, batch, block, display, margin2, rem)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, button, div, form, h2, input, label, p, section, span, text, textarea)
import Html.Styled.Attributes exposing (css, type_)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme
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
        , description = t JoinMetaDescription
        , locale = Nothing
        , title = t JoinMetaTitle -- metadata.title
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
    { title = t JoinMetaTitle
    , body =
        [ viewHeader (t JoinMetaTitle)
        , viewDescription (t JoinDescription)
        , viewForm
        ]
    }


viewHeader : String -> Html msg
viewHeader title =
    section []
        [ h2 [ css [ Theme.pageHeadingStyle ] ] [ text title ]
        ]


viewDescription : String -> Html msg
viewDescription description =
    section [] [ p [] [ text description ] ]


viewForm : Html msg
viewForm =
    form [ css [ formStyle ] ]
        [ label [ css [ formLabelStyling ] ] [ span [] [ text "Name: " ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text "Title: " ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text "Organisation: " ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text "Contact details: " ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text "Message: " ], textarea [] [] ]
        , button [ type_ "submit" ] [ text "Submit" ]
        ]


formStyle : Style
formStyle =
    batch
        [ margin2 (rem 2) (rem 0) ]


formLabelStyling : Style
formLabelStyling =
    batch
        [ display block ]
