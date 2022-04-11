module Theme.TextHeavyPage exposing (view)

import Css exposing (Style, auto, batch, margin2, marginBottom, marginTop, maxWidth, padding2, px, rem)
import Html.Styled exposing (Html, div, h2, section, text)
import Html.Styled.Attributes exposing (css)
import List exposing (concat)
import Theme.Global exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate exposing (HeaderType(..))


view : String -> String -> List (Html msg) -> Html msg
view title subtitle body =
    PageTemplate.view
        { variant = InvisibleHeader
        , intro =
            { title = title
            , bigText = subtitle
            , smallText = []
            }
        }
        (Just (section [ css [ bodyStyle ] ] body))
        Nothing


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
