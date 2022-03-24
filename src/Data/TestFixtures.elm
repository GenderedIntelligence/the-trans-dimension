module Data.TestFixtures exposing (events, news, partners, resources)

import Data.PlaceCal.Events exposing (Realm(..))
import Time



{- These are temporarily part of our src while we build wireframes.
   Once API is functional, we will move this module into `../tests` for use there
-}


partners =
    [ { id = "1"
      , name = "Partner one"
      , summary = "Partner one Info"
      , description = "Partner one intro"
      , address = Just { postalCode = "SE1 1RB" }
      , areasServed = []
      }
    , { id = "2"
      , name = "Partner two"
      , summary = "Partner two Info"
      , description = "Partner two intro"
      , address = Just { postalCode = "WC1N 3XX" }
      , areasServed =
            [ { name = "Central London", abbreviatedName = Just "Central Ldn" }
            ]
      }
    , { id = "3"
      , name = "Partner three"
      , summary = "Partner three Info"
      , description = "Partner three intro"
      , address = Nothing
      , areasServed =
            [ { name = "Birmingham", abbreviatedName = Nothing }
            , { name = "London", abbreviatedName = Nothing }
            ]
      }
    , { id = "4"
      , name = "Partner four"
      , summary = "Partner four Info"
      , description = "Partner four intro"
      , address = Just { postalCode = "N2 2AA" }
      , areasServed = []
      }
    ]


events =
    [ { id = "1"
      , name = "Event 1 name"
      , summary = "A summary of the first event"
      , description = "Fusce at sodales lacus. Morbi scelerisque lacus leo, ac mattis urna ultrices et. Proin ac eros faucibus, consequat ante vel, vulputate lectus. Nunc dictum pharetra ex, eget vestibulum lacus. Maecenas molestie felis in turpis eleifend, nec accumsan massa sodales. Nulla facilisi. Vivamus id rhoncus nulla. Nunc ultricies lectus et dui tempor sodales. Curabitur interdum lectus ultricies est ultricies, at faucibus nisi semper. Praesent iaculis ornare orci. Sed vel metus pharetra, efficitur leo a, porttitor magna. Curabitur sit amet mollis ex."
      , startDatetime = Time.millisToPosix 1645466400000
      , endDatetime = Time.millisToPosix 1650564000000
      , location = "Venue"

      --, realm = Online
      , partnerId = "1"
      }
    , { id = "2"
      , name = "Event 2 name"
      , summary = "A summary of the second event"
      , description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut risus placerat, suscipit lacus quis, pretium nisl. Fusce enim erat, fringilla ac auctor scelerisque, scelerisque non ipsum. Vivamus non elit id orci aliquam lobortis at sit amet ligula. Aenean vel massa pellentesque, viverra turpis et, commodo ipsum. Vivamus nunc elit, elementum et ipsum id, rutrum commodo sapien. Integer eget mi eget lacus sagittis molestie feugiat at lacus. Cras ultrices molestie blandit. Suspendisse gravida tortor non risus vestibulum laoreet. Nam nec quam id nisi suscipit consectetur. Aliquam venenatis tortor elit, id suscipit augue feugiat ac."
      , startDatetime = Time.millisToPosix 1645448400000
      , endDatetime = Time.millisToPosix 1658408400000
      , location = "Venue"

      --, realm = Offline
      , partnerId = "2"
      }
    ]


news =
    [ { id = "1"
      , title = "Some news"
      , summary = "News news news"
      , body = "Integer et nibh porta, pellentesque lacus sit amet, condimentum ligula. Praesent eget lobortis felis, id hendrerit nisl. Vivamus porttitor purus vulputate arcu consequat, vitae condimentum metus molestie. Sed ac consequat eros, vel venenatis metus. Duis laoreet id velit sit amet semper. Nunc placerat risus mi, vitae lacinia lectus rutrum sed. Sed turpis ligula, interdum eu tempor vel, accumsan in arcu. Donec hendrerit molestie sapien, sed suscipit augue. Curabitur eleifend felis magna, nec egestas eros auctor ac. Mauris hendrerit venenatis vestibulum. Aliquam erat volutpat. Aenean commodo gravida est ac dapibus. Vivamus eu lacus sit amet quam sodales consequat. Nullam auctor lacus ac imperdiet fermentum. Pellentesque vel interdum nisi. Aenean malesuada ut nunc eu euismod."
      , datetime = Time.millisToPosix 1645449400000
      , author = "GFSC"
      }
    , { id = "2"
      , title = "Big news!"
      , summary = "Lots of news"
      , body = "Nunc augue erat, ullamcorper et nunc nec, placerat rhoncus nulla. Quisque nec sollicitudin turpis. Etiam risus dolor, ullamcorper vitae consectetur et, faucibus a nunc. Phasellus tempus tellus ligula, dignissim bibendum leo accumsan ac. Phasellus sit amet odio varius augue aliquet venenatis. Vestibulum sit amet mi pulvinar, efficitur tortor non, semper ipsum. In ut faucibus sapien, non pellentesque odio. Morbi orci purus, consequat ut enim non, placerat eleifend neque. Nulla non rhoncus velit. Ut tristique cursus nulla vel consectetur. Fusce in odio vel nunc iaculis pulvinar. Suspendisse a sagittis orci, rutrum mattis justo.\n\n"
      , datetime = Time.millisToPosix 1645559400000
      , author = "GFSC"
      }
    ]


resources =
    [ ( "Resource Category 1"
      , [ { name = "A 1 resource"
          , description = "A short description about resource 1 in the first category."
          , url = "https://one.example.com"
          }
        , { name = "Another 1 resource"
          , description = "A longish description about resource 2 in the first category. This is where we go on and on about the resource. We think it's a good on and will be helpful to many people."
          , url = "https://two.example.com"
          }
        ]
      )
    , ( "Resource Category 2"
      , [ { name = "A 2 resource"
          , description = "A short description about resource 1 in the Second category."
          , url = "https://three.example.com"
          }
        ]
      )
    ]
