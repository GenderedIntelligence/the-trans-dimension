module Theme.TransMarkdown exposing (markdownToHtml, markdownToView)

import Css exposing (Style, absolute, batch, before, center, color, decimal, disc, em, firstChild, fontSize, fontWeight, int, left, lineHeight, listStyle, listStyleType, marginBlockEnd, marginBlockStart, none, paddingLeft, position, property, relative, rem, square, textAlign, textDecoration, top, underline)
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Theme.Global exposing (linkStyle, pink, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp)


markdownToHtml : String -> List (Html.Html msg)
markdownToHtml markdown =
    case markdownToView markdown of
        Ok html ->
            html

        Err _ ->
            []


markdownToView : String -> Result String (List (Html.Html msg))
markdownToView markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    transHtmlRenderer
                    blocks
            )


transHtmlRenderer : Markdown.Renderer.Renderer (Html.Html msg)
transHtmlRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [ css [ headerStyle ] ] children

                Block.H2 ->
                    Html.h2 [ css [ headerStyle, h2Style ] ] children

                Block.H3 ->
                    Html.h3 [ css [ headerStyle ] ] children

                Block.H4 ->
                    Html.h4 [ css [ headerStyle ] ] children

                Block.H5 ->
                    Html.h5 [ css [ headerStyle ] ] children

                Block.H6 ->
                    Html.h6 [ css [ headerStyle ] ] children
    , paragraph = Html.p [ css [ paragraphStyle ] ]
    , hardLineBreak = Html.br [] []
    , strikethrough =
        -- todo add lineThrough style
        \children -> Html.p [] children
    , blockQuote = Html.blockquote []
    , strong =
        \children -> Html.strong [] children
    , emphasis =
        \children -> Html.em [] children
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Attr.href link.destination
                        , Attr.title title
                        , css [ linkStyle ]
                        ]
                        content

                Nothing ->
                    Html.a [ Attr.href link.destination, css [ linkStyle ] ] content
    , image =
        \imageInfo ->
            case imageInfo.title of
                Just title ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        , Attr.title title
                        ]
                        []

                Nothing ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        ]
                        []
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul [ css [ ulStyle ] ]
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    Html.text ""

                                                Block.IncompleteTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [ css [ ulLiStyle ] ] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex, css [ olStyle ] ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li [ css [ olLiStyle ] ]
                                itemBlocks
                        )
                )
    , html = Markdown.Html.oneOf []
    , codeBlock =
        \{ body, language } ->
            Html.pre []
                [ Html.code []
                    [ Html.text body
                    ]
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.td attrs
    }


headerStyle : Style
headerStyle =
    batch
        [ marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , color pink
        , lineHeight (em 1.2)
        ]


h2Style : Style
h2Style =
    batch
        [ textAlign center
        , marginBlockStart (em 2)
        ]


paragraphStyle : Style
paragraphStyle =
    batch
        [ marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , withMediaSmallDesktopUp
            [ fontSize (rem 1.2) ]
        , firstChild
            [ fontSize (rem 1.2)
            , marginBlockEnd (em 2)
            , withMediaTabletLandscapeUp [ fontSize (rem 1.825), lineHeight (em 1.35) ]
            ]
        ]


ulStyle : Style
ulStyle =
    batch
        [ listStyle none
        , marginBlockStart (em 2)
        , marginBlockEnd (em 2)
        ]


olStyle : Style
olStyle =
    batch
        [ listStyleType decimal
        , marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , paddingLeft (em 2)
        ]


ulLiStyle : Style
ulLiStyle =
    batch
        [ paddingLeft (rem 1.5)
        , position relative
        , fontWeight (int 600)
        , withMediaTabletLandscapeUp
            [ marginBlockStart (em 0.5)
            , marginBlockEnd (em 0.5)
            ]
        , before
            [ property "content" "\"\\25A0\""
            , color pink
            , fontSize (em 1.5)
            , position absolute
            , left (rem 0)
            , top (em -0.25)
            ]
        ]


olLiStyle : Style
olLiStyle =
    batch
        [ paddingLeft (em 1)
        ]
