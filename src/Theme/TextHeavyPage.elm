module Theme.TextHeavyPage exposing (view)

import Css exposing (Style, batch, marginBottom, rem)
import Html.Styled exposing (Html, div, h2, section, text)
import Html.Styled.Attributes exposing (css)
import List exposing (concat)
import Theme.Global
import Theme.PageTemplate as PageTemplate


view : String -> String -> List (Html msg) -> Html msg
view title subtitle body =
    PageTemplate.viewNews { title = title, bigText = subtitle, smallText = [] } (Just (section [ css [ bodyStyle ] ] body)) Nothing


bodyStyle : Style
bodyStyle =
    batch [ marginBottom (rem 2) ]
