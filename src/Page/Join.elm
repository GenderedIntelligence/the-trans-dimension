module Page.Join exposing (Data, Model, Msg, page, view)

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
import Theme.Global
import Theme.PageTemplate as PageTemplate exposing (HeaderType(..))
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
        , description = t JoinMetaDescription
        , locale = Nothing
        , title = t JoinTitle -- metadata.title
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
    { title = t JoinTitle
    , body =
        [ PageTemplate.view
            { variant = PinkHeader
            , intro =
                { title = t JoinTitle
                , bigText = t JoinDescription
                , smallText = []
                }
            }
            (Just viewForm)
            Nothing
        ]
    }


viewForm : Html msg
viewForm =
    form [ css [ formStyle ] ]
        [ text "[fFf]"
        , label [ css [ formLabelStyling ] ] [ span [] [ text (t JoinFormInputNameLabel ++ ": ") ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text (t JoinFormInputTitleLabel ++ ": ") ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text (t JoinFormInputOrgLabel ++ ": ") ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text (t JoinFormInputContactLabel ++ ": ") ], input [] [] ]
        , label [ css [ formLabelStyling ] ] [ span [] [ text (t JoinFormInputMessageLabel ++ ": ") ], textarea [] [] ]
        , button [ type_ "submit" ] [ text (t JoinFormSubmitButton) ]
        ]


formStyle : Style
formStyle =
    batch
        [ margin2 (rem 2) (rem 0) ]


formLabelStyling : Style
formLabelStyling =
    batch
        [ display block ]
