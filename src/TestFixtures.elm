module TestFixtures exposing (events, partners)

import PlaceCalTypes exposing (Realm(..))
import Time



{- These are temporarily part of our src while we build wireframes.
   Once API is functional, we will move this module into `../tests` for use there
-}


partners =
    [ { id = "1"
      , name = "Partner one"
      , summary = "Partner one Info"
      , description = "Partner one intro"
      }
    , { id = "2"
      , name = "Partner two"
      , summary = "Partner two Info"
      , description = "Partner two intro"
      }
    , { id = "3"
      , name = "Partner three"
      , summary = "Partner three Info"
      , description = "Partner three intro"
      }
    , { id = "4"
      , name = "Partner four"
      , summary = "Partner four Info"
      , description = "Partner four intro"
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
      , realm = Online
      , partnerId = "1"
      }
    , { id = "2"
      , name = "Event 2 name"
      , summary = "A summary of the second event"
      , description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut risus placerat, suscipit lacus quis, pretium nisl. Fusce enim erat, fringilla ac auctor scelerisque, scelerisque non ipsum. Vivamus non elit id orci aliquam lobortis at sit amet ligula. Aenean vel massa pellentesque, viverra turpis et, commodo ipsum. Vivamus nunc elit, elementum et ipsum id, rutrum commodo sapien. Integer eget mi eget lacus sagittis molestie feugiat at lacus. Cras ultrices molestie blandit. Suspendisse gravida tortor non risus vestibulum laoreet. Nam nec quam id nisi suscipit consectetur. Aliquam venenatis tortor elit, id suscipit augue feugiat ac."
      , startDatetime = Time.millisToPosix 1645448400000
      , endDatetime = Time.millisToPosix 1658408400000
      , location = "Venue"
      , realm = Offline
      , partnerId = "2"
      }
    ]
