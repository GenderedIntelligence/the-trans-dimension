module Site exposing (config)

import DataSource
import Head
import Pages.Manifest as Manifest
import Route
import SiteConfig exposing (SiteConfig)
import Theme.Global exposing (darkBlue)
import Theme.Global exposing (pink)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://transdimension.uk/"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.appleTouchIcon 180 "/favicons/apple-touch-icon.png"
    , Head.icon [ (32, 32) ] "image/png" "/favicons/favicon-32x32.png"
    , Head.icon [ (16, 16) ] "image/png" "/favicons/favicon-16x16.png"
    , Head.metaName "msapplication-TileColor" (Head.raw "#ff7aa7")
    , Head.metaName "theme-color" (Head.raw "#FF7AA7")
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "The Trans Dimension"
        , description = "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place."
        , startUrl = Route.Index |> Route.toPath
        , icons = 
            [ 
                { src = "/favicons/android-chrome-192x192.png"
                , sizes = [ (192, 192) ]
                , mimeType = "image/png"
                , purposes = []
                }
                , { src = "/favicons/android-chrome-512x512.png"
                , sizes = [ (512, 512)]
                , mimeType = "image/png"
                , purposes = []
                }
            ]
        }
    |> Manifest.withBackgroundColor darkBlue
    |> Manifest.withThemeColor pink
