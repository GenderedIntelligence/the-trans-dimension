module Theme.TextHeavyPage exposing (view)

import Css exposing (Style, auto, batch, margin2, marginBottom, marginTop, maxWidth, padding2, px, rem)
import Html.Styled exposing (Html, section)
import Html.Styled.Attributes exposing (css)
import Theme.Global exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate


type alias Msg =
    Never


view : String -> String -> List (Html Msg) -> Html Msg
view title subtitle body =
    PageTemplate.view
        { title = title
        , headerType = Just "invisible"
        , bigText =
            { node = "p"
            , text = subtitle
            }
        , smallText = Nothing
        , innerContent = Just (section [ css [ bodyStyle ] ] body)
        , outerContent = Nothing
        }


bodyStyle : Style
bodyStyle =
    batch
        [ marginBottom (rem 2)
        , marginTop (rem 1)
        , withMediaSmallDesktopUp
            [ marginTop (rem 5) ]
        , withMediaTabletLandscapeUp
            [ maxWidth (px 636)
            , margin2 (rem 4) auto
            ]
        , withMediaTabletPortraitUp
            [ padding2 (rem 0) (rem 2.5)
            , marginTop (rem 3)
            ]
        ]
