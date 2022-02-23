module TestFixtures exposing (events, news, partners)

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
      , name = "Event name"
      , summary = "A summary of the event"
      , description = "Longer description of the event"
      , startDatetime = Time.millisToPosix 1645466400000
      , endDatetime = Time.millisToPosix 1650564000000
      , location = "Venue"
      , online = False
      , partnerId = "1"
      }
    , { id = "2"
      , name = "Event name"
      , summary = "A summary of the event"
      , description = "Longer description of the event"
      , startDatetime = Time.millisToPosix 1645448400000
      , endDatetime = Time.millisToPosix 1658408400000
      , location = "Venue"
      , online = False
      , partnerId = "2"
      }
    ]


news =
    [ { id = "1"
      , title = "Some news"
      , summary = "News news news"
      , body = "Integer et nibh porta, pellentesque lacus sit amet, condimentum ligula. Praesent eget lobortis felis, id hendrerit nisl. Vivamus porttitor purus vulputate arcu consequat, vitae condimentum metus molestie. Sed ac consequat eros, vel venenatis metus. Duis laoreet id velit sit amet semper. Nunc placerat risus mi, vitae lacinia lectus rutrum sed. Sed turpis ligula, interdum eu tempor vel, accumsan in arcu. Donec hendrerit molestie sapien, sed suscipit augue. Curabitur eleifend felis magna, nec egestas eros auctor ac. Mauris hendrerit venenatis vestibulum. Aliquam erat volutpat. Aenean commodo gravida est ac dapibus. Vivamus eu lacus sit amet quam sodales consequat. Nullam auctor lacus ac imperdiet fermentum. Pellentesque vel interdum nisi. Aenean malesuada ut nunc eu euismod."
      , datetime = Time.millisToPosix 0
      , author = "GFSC"
      }
    , { id = "2"
      , title = "Big news!"
      , summary = "Lots of news"
      , body = "Nunc augue erat, ullamcorper et nunc nec, placerat rhoncus nulla. Quisque nec sollicitudin turpis. Etiam risus dolor, ullamcorper vitae consectetur et, faucibus a nunc. Phasellus tempus tellus ligula, dignissim bibendum leo accumsan ac. Phasellus sit amet odio varius augue aliquet venenatis. Vestibulum sit amet mi pulvinar, efficitur tortor non, semper ipsum. In ut faucibus sapien, non pellentesque odio. Morbi orci purus, consequat ut enim non, placerat eleifend neque. Nulla non rhoncus velit. Ut tristique cursus nulla vel consectetur. Fusce in odio vel nunc iaculis pulvinar. Suspendisse a sagittis orci, rutrum mattis justo.\n\n"
      , datetime = Time.millisToPosix 0
      , author = "GFSC"
      }
    ]
