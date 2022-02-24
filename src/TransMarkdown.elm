module TransMarkdown exposing (transHtmlRenderer)

import Css exposing (Style, batch, decimal, disc, em, listStyleType, marginBlockEnd, marginBlockStart, paddingLeft)
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import Markdown.Block as Block exposing (Block)
import Markdown.Html
import Markdown.Renderer


transHtmlRenderer : Markdown.Renderer.Renderer (Html.Html msg)
transHtmlRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [ css [ headerStyle ] ] children

                Block.H2 ->
                    Html.h2 [ css [ headerStyle ] ] children

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
                        ]
                        content

                Nothing ->
                    Html.a [ Attr.href link.destination ] content
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
                                    Html.li [ css [ liStyle ] ] (checkbox :: children)
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
                            Html.li [ css [ liStyle ] ]
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
    batch [ marginBlockStart (em 1), marginBlockEnd (em 1) ]


paragraphStyle : Style
paragraphStyle =
    batch [ marginBlockStart (em 1), marginBlockEnd (em 1) ]


ulStyle : Style
ulStyle =
    batch
        [ listStyleType disc
        , paddingLeft (em 2)
        , marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        ]


olStyle : Style
olStyle =
    batch
        [ listStyleType decimal
        , marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , paddingLeft (em 2)
        ]


liStyle : Style
liStyle =
    batch
        [ paddingLeft (em 1) ]
