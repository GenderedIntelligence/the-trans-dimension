module Data.Resources exposing (ResourceData, resourcesData)


type alias ResourceData =
    { name : String, description : String, url : String }


resourcesData : List ( String, List ResourceData )
resourcesData =
    List.map (\resource -> resourceToHeadingWithData resource) resourcesList



------------------------
-- EDIT CONTENT BELOW --
------------------------
----------------------------
{- Add new categories here -}
-----------------------------


type Resource
    = Acting (List ResourceData)
    | Asylum (List ResourceData)
    | Autism (List ResourceData)
    | ClinicalStudies (List ResourceData)



-------------------------------------------
{- Add Display title for categories here -}
-------------------------------------------


resourceToHeadingWithData : Resource -> ( String, List ResourceData )
resourceToHeadingWithData resource =
    case resource of
        Acting list ->
            ( "Acting", list )

        Asylum list ->
            ( "Asylum", list )

        Autism list ->
            ( "Autism", list )

        ClinicalStudies list ->
            ( "Clinical Studies", list )



--------------------------------------
{- Add resources in categories here -}
--------------------------------------


resourcesList : List Resource
resourcesList =
    [ Acting
        [ { name = "Trans casting statement report"
          , description = "A report proposing that cisgender actors should not be cast in trans or non-binary roles."
          , url = "https://example.com[cCc]"
          }
        , { name = "[cCc] Acting resource"
          , description = "[cCc] Some information about this resource"
          , url = "https://example.com[cCc]"
          }
        ]
    , Asylum
        [ { name = "City of Sanctuary UK"
          , description = "Resources for LGBTQ+ asylum seekers."
          , url = "https://example.com[cCc]"
          }
        , { name = "Rainbow Migration."
          , description = "Guide to asylum applications for LGBTQ+ people."
          , url = "https://example.com[cCc]"
          }
        ]
    , Autism []
    , ClinicalStudies []
    ]
