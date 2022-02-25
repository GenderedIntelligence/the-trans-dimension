module Theme.PageFooter exposing (viewPageFooter)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, backgroundColor, batch, block, borderBox, boxSizing, center, color, display, displayFlex, flexGrow, fontSize, hover, inlineBlock, inlineFlex, justifyContent, marginBottom, marginRight, marginTop, none, nthChild, num, padding, padding2, paddingLeft, pct, rem, right, spaceAround, spaceBetween, textAlign, textDecoration, width)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, button, div, footer, form, h1, input, label, li, nav, p, span, text, ul)
import Html.Styled.Attributes exposing (css, href, target, type_)
import Theme.Global exposing (blue, darkBlue, pink, white)


viewPageFooter : Html msg
viewPageFooter =
    footer [ css [ footerStyle ] ]
        [ viewPageFooterNavigation
        , viewPageFooterLogos
        , viewPageFooterSignup (t FooterSignupText) (t FooterSignupButton)
        , viewPageFooterSocial
        , viewPageFooterInfo (t FooterInfoText) (t FooterInfoContact)
        , viewPageFooterCredit (t FooterCredit)
        ]


viewPageFooterNavigation : Html msg
viewPageFooterNavigation =
    nav [ css [ navStyle ] ]
        [ ul [ css [ navListStyle ] ]
            (List.map viewPageFooterNavigationItem
                [ Home, Partners, Events, NewsList, About, Resources, Privacy, TermsAndConditions ]
            )
        ]


viewPageFooterNavigationItem : TransRoutes.Route -> Html msg
viewPageFooterNavigationItem route =
    li [ css [ navListItemStyle ] ]
        [ a [ href (TransRoutes.toAbsoluteUrl route), css [ navListItemLinkStyle ] ] [ text (TransRoutes.toPageTitle route) ]
        ]


viewPageFooterLogos : Html msg
viewPageFooterLogos =
    div [ css [ blockStyle ] ]
        [ ul [ css [ logoListStyle ] ]
            [ li [] [ text "GFSC logo" ]
            , li [] [ text "GI logo" ]
            , li [] [ text "Comic relief logo" ]
            ]
        ]


viewPageFooterSignup : String -> String -> Html msg
viewPageFooterSignup copyText buttonText =
    --- [fFf] - form handling
    form [ css [ blockStyle, formStyle ] ]
        [ label [ css [ formStyle ] ]
            [ span [] [ text copyText ]
            , input [ type_ "email" ] []
            ]
        , button [ type_ "submit" ] [ text buttonText ]
        ]


viewPageFooterInfo : String -> String -> Html msg
viewPageFooterInfo nameInfo contactInfo =
    div [ css [ blockStyle ] ]
        [ p [ css [ infoParagraphStyle ] ] [ text nameInfo ]
        , p [ css [ infoParagraphStyle ] ] [ text contactInfo ]
        ]


viewPageFooterSocial : Html msg
viewPageFooterSocial =
    div [ css [ blockStyle ] ]
        [ ul
            [ css [ socialListStyle ] ]
            [ li [] [ text "Twitter" ]
            , li [] [ text "Facebook" ]
            , li [] [ text "Instagram" ]
            ]
        ]


viewPageFooterCredit : String -> Html msg
viewPageFooterCredit creditText =
    p [ css [ creditStyle ] ]
        [ a [ href "http://placecal.org", target "_blank", css [ creditLinkStyle ] ] [ text creditText ]
        ]


footerStyle : Style
footerStyle =
    batch
        [ backgroundColor darkBlue
        , marginTop (rem 2)
        ]


blockStyle : Style
blockStyle =
    batch
        [ display inlineBlock
        , width (pct 50)
        , color pink
        , padding (rem 1)
        , boxSizing borderBox
        , nthChild "odd"
            [ width (pct 60)
            ]
        , nthChild "even"
            [ width (pct 40)
            ]
        ]


navStyle : Style
navStyle =
    batch
        [ backgroundColor pink
        , padding (rem 1)
        , marginBottom (rem 2)
        ]


navListStyle : Style
navListStyle =
    batch
        [ displayFlex ]


navListItemStyle : Style
navListItemStyle =
    batch
        [ marginRight (rem 1)
        ]


navListItemLinkStyle : Style
navListItemLinkStyle =
    batch
        [ color darkBlue
        , textDecoration none
        , hover [ color blue ]
        ]


logoListStyle : Style
logoListStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , padding2 (rem 0) (rem 2)
        ]


socialListStyle : Style
socialListStyle =
    batch
        [ displayFlex
        , justifyContent spaceAround
        , padding2 (rem 0) (rem 3)
        ]


formStyle : Style
formStyle =
    batch
        [ color white
        , display inlineFlex
        , justifyContent spaceAround
        , flexGrow (num 1)
        ]


creditStyle : Style
creditStyle =
    batch
        [ textAlign right
        , padding (rem 1)
        ]


creditLinkStyle : Style
creditLinkStyle =
    batch
        [ color white
        , textDecoration none
        ]


infoParagraphStyle : Style
infoParagraphStyle =
    batch
        [ textAlign center
        , marginTop (rem 0)
        , color white
        ]
