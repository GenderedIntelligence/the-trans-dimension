module Theme.PageFooter exposing (viewPageFooter)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, active, after, alignItems, auto, backgroundColor, batch, before, block, border, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, center, color, column, display, displayFlex, firstChild, flexDirection, flexEnd, flexGrow, flexWrap, float, focus, fontSize, fontWeight, hover, inlineBlock, inlineFlex, int, justifyContent, letterSpacing, lineHeight, margin, margin2, margin4, marginBottom, marginRight, marginTop, maxContent, maxWidth, none, nthChild, nthLastChild, num, outline, padding, padding2, padding4, paddingLeft, pct, position, property, px, relative, rem, right, row, solid, spaceAround, spaceBetween, stretch, textAlign, textDecoration, textTransform, top, unset, uppercase, width, wrap)
import Css.Transitions exposing (transition)
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html exposing (sub)
import Html.Styled exposing (Html, a, button, div, footer, form, h1, h4, img, input, label, li, nav, p, span, text, ul)
import Html.Styled.Attributes exposing (css, href, placeholder, src, target, type_)
import List exposing (append)
import Theme.Global exposing (blue, darkBlue, lightPink, pink, white, withMediaMediumDesktopUp, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)


viewPageFooter : Html msg
viewPageFooter =
    footer [ css [ footerStyle ] ]
        [ div [ css [ footerTopSectionStyle ] ]
            [ viewPageFooterLogo
            , viewPageFooterNavigation
            ]
        , div [ css [ footerMiddleSectionStyle ] ]
            [ viewPageFooterSocial (t FooterSocial)
            , viewPageFooterSignup (t FooterSignupText) (t FooterSignupButton)
            , viewPageFooterLogos
            ]
        , viewPageFooterInfo (t FooterInfoTitle) [ t FooterInfoCharity, t FooterInfoCompany, t FooterInfoOffice ]
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
    div [ css [ footerLogoStyle ] ] [ img [ src "/images/logos/TDD_Logo_Footer.svg", css [ footerLogoImageStyle ] ] [] ]


viewPageFooterNavigation : Html msg
viewPageFooterNavigation =
    nav [ css [ navStyle ] ]
        [ ul [ css [ navListStyle ] ]
            (List.map viewPageFooterNavigationItem
                [ Partners, Events, News, About, Resources, Privacy ]
            )
        ]


viewPageFooterNavigationItem : TransRoutes.Route -> Html msg
viewPageFooterNavigationItem route =
    li [ css [ navListItemStyle ] ]
        [ a [ href (TransRoutes.toAbsoluteUrl route), css [ navListItemLinkStyle ] ] [ text (TransRoutes.toPageTitle route) ]
        ]


viewPageFooterLogos : Html msg
viewPageFooterLogos =
    div [ css [ blockStyle, logoBlockStyle ] ]
        [ p [ css [ subheadStyle ] ] [ text "We are supported by" ]
        , ul [ css [ logoListStyle ] ]
            [ li [ css [ logoListItemStyle ] ] [ img [ src "/images/logos/footer_gfsc.svg", css [ logoImageStyle ] ] [] ]
            , li [ css [ logoListItemStyle ] ] [ img [ src "/images/logos/footer_comicrelief.svg ", css [ logoImageStyle ] ] [] ]
            , li [ css [ logoListItemStyle ] ] [ img [ src "/images/logos/GI_pink.png", css [ logoImageStyle, logoGIStyle ] ] [] ]
            ]
        ]


viewPageFooterSignup : String -> String -> Html msg
viewPageFooterSignup copyText buttonText =
    --- [fFf] - form handling
    form [ css [ blockStyle, formStyle, socialBlockStyle ] ]
        [ label [ css [ formStyle ] ]
            [ span [ css [ subheadStyle ] ] [ text copyText ]
            , input [ placeholder "Your email address", type_ "email", css [ formInputStyle ] ] []
            ]
        , button [ type_ "submit", css [ formButtonStyle ] ] [ text buttonText ]
        ]


viewPageFooterInfo : String -> List String -> Html msg
viewPageFooterInfo title info =
    div [ css [ pinkBlockStyle ] ]
        (append
            [ p [ css [ infoParagraphStyle, fontWeight (int 700) ] ]
                [ text title
                ]
            ]
            (List.map
                (\paragraph -> p [ css [ infoParagraphStyle, marginTop (rem 0), marginBottom (rem 0) ] ] [ text paragraph ])
                info
            )
        )


viewPageFooterSocial : String -> Html msg
viewPageFooterSocial socialText =
    div [ css [ blockStyle, socialBlockStyle ] ]
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
    div [ css [ pinkBlockStyle ] ]
        [ p [ css [ infoParagraphStyle, fontWeight (int 700), marginTop (rem 0) ] ]
            [ text creditTitle ]
        , p
            [ css [ infoParagraphStyle ] ]
            (List.map viewPageFooterCreditItem creditList)
        , p [ css [ infoParagraphStyle ] ] [ text (t FooterCopyright) ]
        , img [ src "/images/logos/footer_placecal.svg", css [ poweredByPlaceCalStyle ] ] []
        ]


viewPageFooterCreditItem : { name : String, link : String, text : String } -> Html msg
viewPageFooterCreditItem creditItem =
    span []
        [ text creditItem.text
        , text " "
        , a [ href creditItem.link, target "_blank", css [ creditLinkStyle ] ] [ text creditItem.name ]
        , text ", "
        ]


footerStyle : Style
footerStyle =
    batch
        [ backgroundColor darkBlue
        , marginTop (rem 2)
        ]


footerTopSectionStyle : Style
footerTopSectionStyle =
    batch
        [ withMediaMediumDesktopUp [ padding4 (rem 1) (rem 20) (rem 2) (rem 20) ]
        , withMediaTabletPortraitUp
            [ displayFlex
            , alignItems stretch
            , padding4 (rem 1) (rem 1) (rem 2) (rem 1)
            , backgroundColor pink
            , boxSizing borderBox
            , justifyContent spaceBetween
            , alignItems center
            ]
        ]


footerMiddleSectionStyle : Style
footerMiddleSectionStyle =
    batch
        [ withMediaMediumDesktopUp [ padding2 (rem 1) (rem 10) ]
        , withMediaTabletPortraitUp [ displayFlex, flexWrap wrap, padding (rem 1), justifyContent center ]
        ]


footerLogoStyle : Style
footerLogoStyle =
    batch
        [ padding (rem 1)
        , backgroundColor pink
        , textAlign center
        ]


footerLogoImageStyle : Style
footerLogoImageStyle =
    batch
        [ width (pct 100)
        , maxWidth (px 225)
        , display block
        , margin2 (rem 1) auto
        , withMediaTabletPortraitUp [ margin (rem 0) ]
        ]


blockStyle : Style
blockStyle =
    batch
        [ color pink
        , padding (rem 1)
        , boxSizing borderBox
        ]


pinkBlockStyle : Style
pinkBlockStyle =
    batch
        [ color darkBlue
        , backgroundColor pink
        , padding (rem 1)
        , boxSizing borderBox
        ]


socialBlockStyle : Style
socialBlockStyle =
    batch
        [ withMediaMediumDesktopUp [ maxWidth (pct 20) ]
        , withMediaSmallDesktopUp [ maxWidth (pct 25) ]
        , withMediaTabletPortraitUp [ maxWidth (pct 50), width (pct 100) ]
        ]


logoBlockStyle : Style
logoBlockStyle =
    batch
        [ withMediaMediumDesktopUp [ width (pct 37) ]
        , withMediaSmallDesktopUp [ width (pct 50) ]
        , withMediaTabletLandscapeUp [ width (pct 70) ]
        , withMediaTabletPortraitUp [ width (pct 100) ]
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
        , withMediaTabletPortraitUp [ margin2 (rem 1) auto ]
        ]


navStyle : Style
navStyle =
    batch
        [ backgroundColor pink
        , padding4 (rem 1) (rem 1) (rem 3) (rem 1)
        , marginBottom (rem 1)
        , withMediaTabletPortraitUp [ marginBottom (rem 0), padding (rem 1), maxWidth (pct 55) ]
        ]


navListStyle : Style
navListStyle =
    batch
        [ withMediaTabletPortraitUp [ displayFlex, flexWrap wrap, justifyContent flexEnd ] ]


navListItemStyle : Style
navListItemStyle =
    batch
        [ textAlign center
        , fontWeight (int 600)
        , margin (rem 0.5)
        , fontSize (rem 1.1)
        , withMediaTabletPortraitUp [ marginRight (rem 1), margin2 (rem 0) (rem 0.5) ]
        ]


navListItemLinkStyle : Style
navListItemLinkStyle =
    batch
        [ color darkBlue
        , textDecoration none
        , transition [ Css.Transitions.color 300 ]
        , hover [ color white ]
        ]


logoListStyle : Style
logoListStyle =
    batch
        [ displayFlex
        , flexDirection column
        , justifyContent spaceBetween
        , padding2 (rem 0) (rem 2)
        , margin2 (rem 2) (rem 0)
        , withMediaSmallDesktopUp [ justifyContent spaceBetween ]
        , withMediaTabletPortraitUp [ flexDirection row, justifyContent spaceAround ]
        ]


logoListItemStyle : Style
logoListItemStyle =
    batch
        [ textAlign center
        , position relative
        , after
            [ property "content" "\"+\""
            , display block
            , color white
            , fontSize (rem 2)
            , margin (rem 1)
            , textAlign center
            , withMediaTabletPortraitUp [ position absolute ]
            , right (rem -4)
            , top (rem -1)
            ]
        , nthLastChild "1" [ after [ display none ] ]
        ]


logoImageStyle : Style
logoImageStyle =
    batch
        [ margin2 (rem 0) auto
        ]


logoGIStyle : Style
logoGIStyle =
    batch
        [ width (px 175) ]


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
        [ margin2 (rem 0) (rem 1)
        ]


formStyle : Style
formStyle =
    batch
        [ color white
        , flexGrow (num 1)
        , withMediaTabletPortraitUp
            [ displayFlex
            , flexWrap wrap
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
        , withMediaTabletPortraitUp [ marginTop (rem 0) ]
        ]


formButtonStyle : Style
formButtonStyle =
    batch
        [ display block
        , maxWidth maxContent
        , backgroundColor pink
        , margin2 (rem 0) auto
        , borderStyle none
        , borderRadius (rem 0.2)
        , padding2 (rem 0.4) (rem 0.7)
        , fontWeight (int 700)
        , transition [ Css.Transitions.backgroundColor 300 ]
        , hover [ backgroundColor lightPink ]
        , focus [ backgroundColor lightPink ]
        , active [ backgroundColor white ]
        ]


infoParagraphStyle : Style
infoParagraphStyle =
    batch
        [ textAlign center
        , fontSize (rem 0.8777)
        , margin2 (rem 1) (rem 2)
        , lineHeight (rem 1.13)
        ]


creditLinkStyle : Style
creditLinkStyle =
    batch
        [ color darkBlue ]


poweredByPlaceCalStyle : Style
poweredByPlaceCalStyle =
    batch
        [ margin4 (rem 3) auto (rem 1) auto ]
