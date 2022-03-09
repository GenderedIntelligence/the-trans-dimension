module Theme.PageHeader exposing (viewPageHeader)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, backgroundColor, batch, block, bold, border, borderBox, boxSizing, center, color, column, columnReverse, display, displayFlex, flexDirection, flexGrow, fontSize, fontWeight, hex, hover, int, justifyContent, lighter, margin, margin2, marginRight, marginTop, none, padding, paddingBottom, paddingLeft, paddingTop, pct, rem, row, spaceBetween, textAlign, textDecoration, transparent, unset, width, zero)
import Css.Media exposing (grid)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, button, div, h1, header, li, nav, p, span, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Theme.Global as Theme exposing (black, blue, darkBlue, pink, white, withMediaTabletPortraitUp)
import Theme.Logo


headerNavigationItems : List Route
headerNavigationItems =
    [ Home, Partners, Events, News, About, Resources ]


viewPageHeader : Html msg
viewPageHeader =
    header [ css [ headerStyle ] ]
        [ div [ css [ barStyle ] ]
            [ viewPageHeaderNavigation headerNavigationItems
            , viewPageHeaderAsk (t HeaderAskButton) (t HeaderAskLink)
            ]
        , div [ css [ titleBarStyle ] ]
            [ viewPageHeaderTitle (t SiteTitle) (t SiteStrapline)
            , viewPageHeaderMenuButton (t HeaderMobileMenuButton)
            ]
        ]


viewPageHeaderTitle : String -> String -> Html msg
viewPageHeaderTitle pageTitle strapLine =
    div [ css [ titleStyle ] ]
        [ h1 [] [ Theme.Logo.view ]
        ]


viewPageHeaderNavigation : List Route -> Html msg
viewPageHeaderNavigation listItems =
    nav []
        [ ul [ css [ navigationListStyle ] ]
            (List.map viewHeaderNavigationItem
                listItems
            )
        ]


viewHeaderNavigationItem : TransRoutes.Route -> Html msg
viewHeaderNavigationItem route =
    li [ css [ navigationListItemStyle ] ]
        [ a [ href (TransRoutes.toAbsoluteUrl route), css [ navigationLinkStyle ] ]
            [ text (TransRoutes.toPageTitle route)
            ]
        ]


viewPageHeaderAsk : String -> String -> Html msg
viewPageHeaderAsk copyText linkTo =
    div [ css [ askStyle ] ]
        [ a [ href linkTo, css [ askButtonStyle ] ] [ text copyText ]
        ]


viewPageHeaderMenuButton : String -> Html msg
viewPageHeaderMenuButton buttonText =
    div [ css [ menuButtonStyle ] ]
        [ button [ css [ menuButtonButtonStyle ] ] [ span [ css [ buttonTextStyle ] ] [ text buttonText ], span [ css [ buttonCrossStyle ] ] [ text "+" ] ]
        ]


headerStyle : Style
headerStyle =
    batch
        [ displayFlex
        , flexDirection columnReverse
        , textAlign center
        , color white
        , paddingBottom (rem 1)
        ]


titleBarStyle : Style
titleBarStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        ]


titleStyle : Style
titleStyle =
    batch
        [ margin (rem 1)
        ]


barStyle : Style
barStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex
            , justifyContent spaceBetween
            , padding (rem 1)
            ]
        ]


menuButtonStyle : Style
menuButtonStyle =
    batch
        [ withMediaTabletPortraitUp
            [ display none
            ]
        ]


menuButtonButtonStyle : Style
menuButtonButtonStyle =
    batch
        [ backgroundColor transparent
        , border zero
        , margin2 (rem 2) (rem 1)
        , displayFlex
        , alignItems center
        ]


buttonTextStyle : Style
buttonTextStyle =
    batch
        [ color white
        , marginRight (rem 0.5)
        ]


buttonCrossStyle : Style
buttonCrossStyle =
    batch
        [ color pink
        , fontSize (rem 4)
        , fontWeight lighter
        , display block
        , margin2 (rem -1.75) (rem 0)
        ]


navigationListStyle : Style
navigationListStyle =
    batch
        [ displayFlex
        , flexDirection column
        , flexGrow (int 2)
        , withMediaTabletPortraitUp
            [ flexDirection row
            , fontSize (rem 1.1)
            , paddingLeft (rem 1)
            ]
        ]


navigationListItemStyle : Style
navigationListItemStyle =
    batch
        [ backgroundColor pink
        , display block
        , padding (rem 1)
        , boxSizing borderBox
        , margin2 (rem 0.1) (rem 0)
        , fontSize (rem 1.2)
        ]


navigationLinkStyle : Style
navigationLinkStyle =
    batch
        [ fontWeight (int 600)
        , color black
        , textDecoration none
        , display block
        , hover [ color pink ]
        ]


askStyle : Style
askStyle =
    batch
        [ display none
        , withMediaTabletPortraitUp [ display unset ]
        ]


askButtonStyle : Style
askButtonStyle =
    batch
        [ display block
        , backgroundColor pink
        , color black
        , textDecoration none
        , padding (rem 1)
        , width (rem 5)
        , textAlign center
        , fontWeight bold
        ]
