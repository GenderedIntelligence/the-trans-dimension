module TestFixtures exposing (events, partners)

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
      , startDatetime = ""
      , endDatetime = ""
      , location = "Venue"
      , online = False
      , partnerId = "1"
      }
    , { id = "2"
      , name = "Event name"
      , summary = "A summary of the event"
      , description = "Longer description of the event"
      , startDatetime = ""
      , endDatetime = ""
      , location = "Venue"
      , online = False
      , partnerId = "2"
      }
    ]
