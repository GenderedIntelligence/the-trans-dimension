module PageHeader exposing (viewPageHeader)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Theme exposing (pink)
import Css exposing (Style, batch, color, fontSize, hex, rem, displayFlex, justifyContent, width, pct, marginRight, display, backgroundColor, textDecoration, none, center, textAlign)
import Html.Styled exposing (Html, a, div, h1, header, li, nav, p, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Css exposing (spaceBetween)
import Css exposing (padding)
import Css exposing (block)
import Css.Media exposing (grid)


viewPageHeader : Html msg
viewPageHeader =
    header [ css [ headerStyle ]]
        [ div [ css [ barStyle ]] [ 
                    viewPageHeaderNavigation ""
                    , viewPageHeaderAsk (t SiteHeaderAskButton) "http://donate.com"
        ]
        , viewPageHeaderTitle (t SiteTitle) (t SiteStrapline)
        ]


viewPageHeaderTitle : String -> String -> Html msg
viewPageHeaderTitle pageTitle strapLine =
    div [ ]
        [ h1 [ css [ titleStyle ] ] [ text pageTitle ]
        , p [] [ text strapLine ]
        ]


viewPageHeaderNavigation : String -> Html msg
viewPageHeaderNavigation listItems =
    nav []
        [ ul [ css [ navigationListStyle ]]
            [ li [ css [ navigationListItemStyle ]] [ text "Item 1" ]
            , li [ css [ navigationListItemStyle ]] [ text "Item 2" ]
            , li [ css [ navigationListItemStyle ]] [ text "Item 3" ]
            ]
        ]


viewPageHeaderAsk : String -> String -> Html msg
viewPageHeaderAsk copyText linkTo =
    div []
        [ a [ href linkTo, css [ askButtonStyle ] ] [ text copyText ]
        ]

headerStyle : Style
headerStyle =
    batch
        [
            padding (rem 1)
            , textAlign center
        ]

titleStyle : Style
titleStyle =
    batch
        [ fontSize (rem 2)
        , color (hex "000000")
        ]

barStyle : Style
barStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
         ]

navigationListStyle : Style
navigationListStyle =
    batch
        [ displayFlex
        , fontSize (rem 1)
        ]

navigationListItemStyle : Style
navigationListItemStyle =
    batch
        [ marginRight (rem 1)
        ]

askButtonStyle : Style
askButtonStyle =
    batch
        [ display block
        , backgroundColor pink
        , color (hex "000000")
        , textDecoration none
        , padding (rem 1)
        , width (rem 5)
        , textAlign center
        ]