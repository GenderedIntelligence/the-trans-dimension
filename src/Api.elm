module Api exposing (placeCalApiUrl, routes)

import ApiRoute
import DataSource exposing (DataSource)
import Html exposing (Html)
import Route exposing (Route)


placeCalApiUrl : String
placeCalApiUrl =
    -- Production
    "https://placecal.org/api/v1/graphql"



-- Dev
--"http://localhost:3000/api/v1/graphql"
-- Staging
--"https://placecal-staging.org/api/v1/graphql"


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    []
