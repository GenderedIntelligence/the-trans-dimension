module Data.PlaceCal.Api exposing (getDataFromPlaceCal)

import BackendTask
import BackendTask.Http
import Constants
import FatalError
import Json.Decode
import Url.Builder


getDataFromPlaceCal : String -> Json.Decode.Decoder response -> BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Http.Error } response
getDataFromPlaceCal queryString decoder =
    BackendTask.Http.getWithOptions
        { url = requestUrlFromQueryString queryString
        , expect = BackendTask.Http.expectJson decoder
        , headers = []
        , cacheStrategy = Just BackendTask.Http.ForceCache
        , retries = Nothing
        , timeoutInMs = Nothing
        , cachePath = Nothing
        }


requestUrlFromQueryString : String -> String
requestUrlFromQueryString queryString =
    Constants.placecalApi
        ++ Url.Builder.toQuery
            [ Url.Builder.string "query" queryString ]
