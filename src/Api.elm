module Api exposing (placeCalApiUrl, routes)

import ApiRoute
import Constants exposing (placecalApi)
import DataSource exposing (DataSource)
import Html exposing (Html)
import Route exposing (Route)


placeCalApiUrl : String
placeCalApiUrl =
    placecalApi


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    []
