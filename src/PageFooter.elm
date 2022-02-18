module PageFooter exposing (viewPageFooter)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, backgroundColor, batch, block, borderBox, boxSizing, center, color, display, displayFlex, flexGrow, fontSize, inlineBlock, inlineFlex, justifyContent, marginBottom, marginRight, marginTop, none, nthChild, num, padding, padding2, paddingLeft, pct, rem, right, spaceAround, spaceBetween, textAlign, textDecoration, width)
import Html.Styled exposing (Html, a, button, div, footer, form, h1, input, label, li, nav, p, span, text, ul)
import Html.Styled.Attributes exposing (css, href, target, type_)
import Theme exposing (darkBlue, pink, white)


viewPageFooter : Html msg
viewPageFooter =
    footer [ css [ footerStyle ] ]
        [ viewPageFooterNavigation ""
        , viewPageFooterLogos
        , viewPageFooterSignup (t SiteFooterSignupText) (t SiteFooterSignupButton)
        , viewPageFooterSocial
        , viewPageFooterInfo (t SiteFooterInfoText) (t SiteFooterInfoContact)
        , viewPageFooterCredit (t SiteFooterCredit)
        ]


viewPageFooterNavigation : String -> Html msg
viewPageFooterNavigation _ =
    nav [ css [ navStyle ] ]
        [ ul [ css [ navListStyle ] ]
            [ li [ css [ navListItemStyle ] ] [ text "Item 1" ]
            , li [ css [ navListItemStyle ] ] [ text "Item 2" ]
            , li [ css [ navListItemStyle ] ] [ text "Item 3" ]
            ]
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
