module Theme.PageFooter exposing (viewPageFooter)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, active, backgroundColor, batch, block, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, center, color, display, displayFlex, flexGrow, float, focus, fontSize, fontWeight, hover, inlineBlock, inlineFlex, int, justifyContent, letterSpacing, lineHeight, margin, margin2, margin4, marginBottom, marginRight, marginTop, none, nthChild, num, outline, padding, padding2, paddingLeft, pct, px, rem, right, solid, spaceAround, spaceBetween, textAlign, textDecoration, textTransform, uppercase, width)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html exposing (sub)
import Html.Styled exposing (Html, a, button, div, footer, form, h1, h4, img, input, label, li, nav, p, span, text, ul)
import Html.Styled.Attributes exposing (css, href, placeholder, src, target, type_)
import Theme.Global exposing (blue, darkBlue, pink, white, withMediaTabletPortraitUp)


viewPageFooter : Html msg
viewPageFooter =
    footer [ css [ footerStyle ] ]
        [ viewPageFooterLogo
        , viewPageFooterNavigation
        , viewPageFooterSocial (t FooterSocial)
        , viewPageFooterSignup (t FooterSignupText) (t FooterSignupButton)
        , viewPageFooterLogos
        , viewPageFooterInfo (t FooterInfoText) (t FooterInfoContact)
        , viewPageFooterCredit (t FooterCreditTitle)
            [ { name = t FooterCredit1Name
              , link = t FooterCredit1Link
              , text = t FooterCredit1Text
              }
            , { name = t FooterCredit2Name
              , link = t FooterCredit2Link
              , text = t FooterCredit2Text
              }
            , { name = t FooterCredit3Name
              , link = t FooterCredit3Link
              , text = t FooterCredit3Text
              }
            ]
        ]


viewPageFooterLogo : Html msg
viewPageFooterLogo =
    div [ css [ footerLogoStyle ] ] [ text "logo" ]


viewPageFooterNavigation : Html msg
viewPageFooterNavigation =
    nav [ css [ navStyle ] ]
        [ ul [ css [ navListStyle ] ]
            (List.map viewPageFooterNavigationItem
                [ Partners, Events, News, About, Resources, Privacy, TermsAndConditions ]
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
        [ p [ css [ subheadStyle ] ] [ text "We are supported by" ]
        , ul [ css [ logoListStyle ] ]
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
            [ span [ css [ subheadStyle ] ] [ text copyText ]
            , input [ placeholder "Your email address", type_ "email", css [ formInputStyle ] ] []
            ]
        , button [ type_ "submit" ] [ text buttonText ]
        ]


viewPageFooterInfo : String -> String -> Html msg
viewPageFooterInfo nameInfo contactInfo =
    div [ css [ blockStyle ] ]
        [ p [ css [ infoParagraphStyle ] ] [ text nameInfo ]
        , p [ css [ infoParagraphStyle ] ] [ text contactInfo ]
        ]


viewPageFooterSocial : String -> Html msg
viewPageFooterSocial socialText =
    div [ css [ blockStyle ] ]
        [ p [ css [ subheadStyle ] ] [ text socialText ]
        , ul
            [ css [ socialListStyle ] ]
            [ li [ css [ socialListItemStyle ] ] [ img [ src "/images/logos/footer_insta.svg" ] [] ]
            , li [ css [ socialListItemStyle ] ] [ img [ src "/images/logos/footer_twitter.svg" ] [] ]
            , li [ css [ socialListItemStyle ] ] [ img [ src "/images/logos/footer_facebook.svg" ] [] ]
            ]
        ]


viewPageFooterCredit : String -> List { name : String, link : String, text : String } -> Html msg
viewPageFooterCredit creditTitle creditList =
    div []
        [ h4 []
            [ text creditTitle ]
        , p
            [ css [ creditStyle ] ]
            (List.map viewPageFooterCreditItem creditList)
        ]


viewPageFooterCreditItem : { name : String, link : String, text : String } -> Html msg
viewPageFooterCreditItem creditItem =
    span []
        [ text creditItem.text
        , text " "
        , a [ href creditItem.link, target "_blank" ] [ text creditItem.name ]
        , text ", "
        ]


footerStyle : Style
footerStyle =
    batch
        [ backgroundColor darkBlue
        , marginTop (rem 2)
        ]


footerLogoStyle : Style
footerLogoStyle =
    batch
        [ padding (rem 1)
        , backgroundColor pink
        , textAlign center
        ]


blockStyle : Style
blockStyle =
    batch
        [ color pink
        , padding (rem 1)
        , boxSizing borderBox
        ]


subheadStyle : Style
subheadStyle =
    batch
        [ color white
        , textTransform uppercase
        , fontWeight (int 700)
        , letterSpacing (px 1.9)
        , textAlign center
        , lineHeight (rem 1.75)
        , display block
        , margin4 (rem 0.5) (rem 0) (rem 1) (rem 0)
        ]


navStyle : Style
navStyle =
    batch
        [ backgroundColor pink
        , padding (rem 1)
        , marginBottom (rem 1)
        ]


navListStyle : Style
navListStyle =
    batch
        [ withMediaTabletPortraitUp [ displayFlex ] ]


navListItemStyle : Style
navListItemStyle =
    batch
        [ textAlign center
        , fontWeight (int 600)
        , margin (rem 0.5)
        , fontSize (rem 1.1)
        , withMediaTabletPortraitUp [ marginRight (rem 1) ]
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
        , justifyContent center
        , margin2 (rem 1) (rem 0)
        ]


socialListItemStyle : Style
socialListItemStyle =
    batch
        [ margin2 (rem 0) (rem 1) ]


formStyle : Style
formStyle =
    batch
        [ color white
        , flexGrow (num 1)
        , withMediaTabletPortraitUp
            [ display inlineFlex
            , justifyContent spaceAround
            ]
        ]


formInputStyle : Style
formInputStyle =
    batch
        [ display block
        , backgroundColor darkBlue
        , borderWidth (px 2)
        , borderStyle solid
        , borderColor pink
        , borderRadius (px 5)
        , width (pct 100)
        , color white
        , textAlign center
        , padding2 (rem 0.25) (rem 0.5)
        , boxSizing borderBox
        , margin2 (rem 1) (rem 0)
        , focus [ outline none, borderColor white ]
        ]


creditStyle : Style
creditStyle =
    batch
        [ padding (rem 1)
        ]


infoParagraphStyle : Style
infoParagraphStyle =
    batch
        [ textAlign center
        , marginTop (rem 0)
        , color white
        ]
