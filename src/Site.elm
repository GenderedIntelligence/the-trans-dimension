module Site exposing (config)

import Constants exposing (canonicalUrl)
import DataSource
import Head
import MimeType
import Pages.Manifest as Manifest
import Pages.Url
import Path
import Route
import SiteConfig exposing (SiteConfig)
import Theme.Global


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = canonicalUrl
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.appleTouchIcon (Just 180) (pathFromString "/favicons/apple-touch-icon.png")
    , Head.metaName "msapplication-TileColor" (Head.raw "#ff7aa7")
    , Head.metaName "theme-color" (Head.raw "#FF7AA7")
    ]
        ++ icons
            [ ( 32, "favicon-32x32.png" )
            , ( 16, "favicon-16x16.png" )
            ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "The Trans Dimension"
        , description = "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place."
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ { src = pathFromString "/favicons/android-chrome-192x192.png"
              , sizes = [ ( 192, 192 ) ]
              , mimeType = Just MimeType.Png
              , purposes = []
              }
            , { src = pathFromString "/favicons/android-chrome-512x512.png"
              , sizes = [ ( 512, 512 ) ]
              , mimeType = Just MimeType.Png
              , purposes = []
              }
            ]
        }
        |> Manifest.withBackgroundColor Theme.Global.darkBlueRgbColor
        |> Manifest.withThemeColor Theme.Global.pinkRgbColor


pathFromString : String -> Pages.Url.Url
pathFromString srcString =
    Pages.Url.fromPath <| Path.fromString srcString


icons : List ( Int, String ) -> List Head.Tag
icons iconConfigList =
    List.map
        (\( size, src ) ->
            Head.icon [ ( size, size ) ]
                MimeType.Png
                (("/favicons/" ++ src)
                    |> pathFromString
                )
        )
        iconConfigList
