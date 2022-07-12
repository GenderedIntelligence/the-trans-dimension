module Theme.PageHeader exposing (viewPageHeader)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, alignSelf, auto, backgroundColor, batch, block, border, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderRadius, boxSizing, center, color, column, columnReverse, cursor, display, displayFlex, flexDirection, flexGrow, flexWrap, fontSize, fontWeight, hover, int, justifyContent, lighter, margin, margin2, marginLeft, marginRight, none, padding, padding2, padding4, paddingBottom, paddingLeft, pointer, rem, row, solid, spaceBetween, textAlign, textDecoration, transparent, unset, wrap, zero)
import Css.Transitions exposing (transition)
import Helpers.TransRoutes as TransRoutes exposing (..)
import Html.Styled exposing (Html, a, button, div, h1, header, li, nav, span, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Messages exposing (Msg(..))
import Path exposing (Path)
import Route exposing (Route)
import Theme.Global as Theme exposing (darkBlue, pink, white, withMediaTabletPortraitUp)
import Theme.Logo


headerNavigationItems : List TransRoutes.Route
headerNavigationItems =
    [ Home, Events, Partners, News, About, Donate ]


viewPageHeader : { path : Path, route : Maybe Route } -> Bool -> Html Msg
viewPageHeader currentPath showMobileMenu =
    header [ css [ headerStyle ] ]
        [ div [ css [ barStyle ] ]
            [ viewPageHeaderNavigation showMobileMenu headerNavigationItems currentPath.path

            -- , viewPageHeaderAsk (t HeaderAskButton) (t HeaderAskLink)
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


viewPageHeaderNavigation : Bool -> List TransRoutes.Route -> Path -> Html Msg
viewPageHeaderNavigation showMobileMenu listItems currentPath =
    nav []
        [ ul
            [ css
                ([ navigationListStyle ]
                    ++ (if showMobileMenu then
                            []

                        else
                            [ display none, withMediaTabletPortraitUp [ displayFlex ] ]
                       )
                )
            ]
            (List.map
                (\item ->
                    if TransRoutes.toAbsoluteUrl item == "/" then
                        viewHeaderNavigationItem item

                    else if TransRoutes.toAbsoluteUrl item == Path.toAbsolute currentPath then
                        viewHeaderNavigationItemCurrent item

                    else if String.contains (TransRoutes.toAbsoluteUrl item) (Path.toAbsolute currentPath) then
                        viewHeaderNavigationItemCurrentCategory item

                    else if TransRoutes.toAbsoluteUrl item == "/donate" then
                        viewPageHeaderAsk (t HeaderAskButton) (t HeaderAskLink)

                    else
                        viewHeaderNavigationItem item
                )
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


viewHeaderNavigationItemCurrent : TransRoutes.Route -> Html Msg
viewHeaderNavigationItemCurrent route =
    li [ css [ navigationListItemStyle ] ]
        [ span [ css [ navigationCurrentStyle ] ]
            [ text (TransRoutes.toPageTitle route)
            ]
        ]


viewHeaderNavigationItemCurrentCategory : TransRoutes.Route -> Html Msg
viewHeaderNavigationItemCurrentCategory route =
    li [ css [ navigationListItemStyle ] ]
        [ a [ href (TransRoutes.toAbsoluteUrl route), css [ navigationLinkCurrentCategoryStyle ] ]
            [ text (TransRoutes.toPageTitle route)
            ]
        ]


viewPageHeaderAsk : String -> String -> Html Msg
viewPageHeaderAsk copyText linkTo =
    li [ css [ navigationListItemStyle, askStyle ] ]
        [ a
            [ href linkTo
            , css
                [ navigationLinkStyle
                , askButtonStyle
                ]
            ]
            [ text copyText ]
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
            [ backgroundColor pink
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
        [ alignItems center
        , backgroundColor transparent
        , border zero
        , cursor pointer
        , displayFlex
        , margin2 (rem 2) (rem 1)
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
        , withMediaTabletPortraitUp
            [ padding2 (rem 1) (rem 0.75)
            , alignSelf center
            ]
        ]


navigationLinkStyle : Style
navigationLinkStyle =
    batch
        [ fontWeight (int 600)
        , color darkBlue
        , textDecoration none
        , display block
        , borderBottomWidth (rem 0.2)
        , borderBottomStyle solid
        , borderBottomColor pink
        , transition [ Theme.borderTransition ]
        , hover [ color white ]
        , withMediaTabletPortraitUp [ hover [ borderBottomColor darkBlue ] ]
        ]


navigationCurrentStyle : Style
navigationCurrentStyle =
    batch
        [ fontWeight (int 600)
        , color darkBlue
        , textDecoration none
        , display block
        , withMediaTabletPortraitUp
            [ borderBottomColor darkBlue
            , borderBottomWidth (rem 0.2)
            , borderBottomStyle solid
            ]
        , transition [ Theme.borderTransition ]
        ]


navigationLinkCurrentCategoryStyle : Style
navigationLinkCurrentCategoryStyle =
    batch
        [ fontWeight (int 600)
        , color darkBlue
        , textDecoration none
        , display block
        , withMediaTabletPortraitUp
            [ borderBottomColor darkBlue
            , borderBottomWidth (rem 0.2)
            , borderBottomStyle solid
            ]
        , hover [ color white ]
        , transition [ Theme.colorTransition, Theme.borderTransition ]
        ]


askStyle : Style
askStyle =
    batch
        [ padding (rem 0)
        , withMediaTabletPortraitUp
            [ marginLeft auto
            , display unset
            ]
        ]


askButtonStyle : Style
askButtonStyle =
    batch
        [ backgroundColor white
        , borderBottomStyle none
        , padding (rem 1)
        , hover [ color pink ]
        , withMediaTabletPortraitUp
            [ padding4 (rem 0.375) (rem 1.25) (rem 0.5) (rem 1.25)
            , borderRadius (rem 0.3)
            ]
        ]
