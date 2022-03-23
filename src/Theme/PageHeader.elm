module Theme.PageHeader exposing (viewPageHeader)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, active, alignItems, backgroundColor, batch, block, bold, border, borderBottom, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, center, color, column, columnReverse, display, displayFlex, flexDirection, flexGrow, flexWrap, focus, fontSize, fontWeight, hex, hover, int, justifyContent, lighter, margin, margin2, marginRight, marginTop, none, padding, padding2, paddingBottom, paddingLeft, paddingTop, pct, rem, row, solid, spaceBetween, textAlign, textDecoration, transparent, unset, width, wrap, zero)
import Css.Media exposing (grid)
import Css.Transitions exposing (easeIn, transition)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, button, div, h1, header, li, nav, p, span, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Messages exposing (Msg(..))
import Theme.Global as Theme exposing (black, blue, darkBlue, pink, purple, white, withMediaTabletPortraitUp)
import Theme.Logo


headerNavigationItems : List Route
headerNavigationItems =
    [ Home, Partners, Events, News, About, Resources ]


viewPageHeader : Bool -> Html Msg
viewPageHeader showMobileMenu =
    header [ css [ headerStyle ] ]
        [ div [ css [ barStyle ] ]
            [ viewPageHeaderNavigation showMobileMenu headerNavigationItems
            , viewPageHeaderAsk (t HeaderAskButton) (t HeaderAskLink)
            ]
        , div [ css [ titleBarStyle ] ]
            [ viewPageHeaderTitle (t SiteTitle) (t SiteStrapline)
            , viewPageHeaderMenuButton (t HeaderMobileMenuButton)
            ]
        ]


viewPageHeaderTitle : String -> String -> Html Msg
viewPageHeaderTitle pageTitle strapLine =
    div [ css [ titleStyle ] ]
        [ h1 [] [ Theme.Logo.view ]
        ]


viewPageHeaderNavigation : Bool -> List Route -> Html Msg
viewPageHeaderNavigation showMobileMenu listItems =
    nav []
        [ ul
            [ css
                ([ navigationListStyle ]
                    ++ (if showMobileMenu then
                            []

                        else
                            [ display none ]
                       )
                )
            ]
            (List.map viewHeaderNavigationItem
                listItems
            )
        ]


viewHeaderNavigationItem : TransRoutes.Route -> Html Msg
viewHeaderNavigationItem route =
    li [ css [ navigationListItemStyle ] ]
        [ a [ href (TransRoutes.toAbsoluteUrl route), css [ navigationLinkStyle ] ]
            [ text (TransRoutes.toPageTitle route)
            ]
        ]


viewPageHeaderAsk : String -> String -> Html Msg
viewPageHeaderAsk copyText linkTo =
    div [ css [ askStyle ] ]
        [ a [ href linkTo, css [ askButtonStyle ] ] [ text copyText ]
        ]


viewPageHeaderMenuButton : String -> Html Msg
viewPageHeaderMenuButton buttonText =
    div [ css [ menuButtonStyle ] ]
        [ button
            [ onClick ToggleMenu
            , css [ menuButtonButtonStyle ]
            ]
            [ span [ css [ buttonTextStyle ] ] [ text buttonText ]
            , span [ css [ buttonCrossStyle ] ] [ text "+" ]
            ]
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
        , withMediaTabletPortraitUp [ display none ]
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
            , padding (rem 0.5)
            , backgroundColor pink
            , alignItems center
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
            , paddingLeft (rem 0.5)
            , flexWrap wrap
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
        , withMediaTabletPortraitUp [ padding2 (rem 1) (rem 0.75) ]
        ]


navigationLinkStyle : Style
navigationLinkStyle =
    batch
        [ fontWeight (int 600)
        , color black
        , textDecoration none
        , display block
        , borderBottomWidth (rem 0.2)
        , borderBottomStyle solid
        , borderBottomColor pink
        , transition [ Css.Transitions.borderBottom 300, Css.Transitions.color 300 ]
        , hover [ color white ]
        , withMediaTabletPortraitUp [ hover [ borderBottomColor black ] ]
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
        , backgroundColor white
        , color black
        , textDecoration none
        , padding2 (rem 0.5) (rem 0.75)
        , width (rem 5)
        , textAlign center
        , fontWeight bold
        , fontSize (rem 1.1)
        , borderRadius (rem 0.3)
        , marginRight (rem 1)
        , hover [ backgroundColor purple, color white ]
        , active [ backgroundColor darkBlue, color white ]
        , focus [ backgroundColor darkBlue, color white ]
        , borderWidth (rem 0.2)
        , borderColor white
        , borderStyle solid
        , transition [ Css.Transitions.backgroundColor 500, Css.Transitions.color 500, Css.Transitions.border 500 ]
        ]
