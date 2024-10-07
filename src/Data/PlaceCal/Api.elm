module Data.PlaceCal.Api exposing (fetchAndCachePlaceCalData)

import BackendTask
import BackendTask.Custom
import Constants
import FatalError
import Json.Decode
import Json.Encode


fetchAndCachePlaceCalData :
    String
    -> Json.Encode.Value
    -> (Json.Decode.Decoder a -> BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Custom.Error } a)
fetchAndCachePlaceCalData collection query =
    BackendTask.Custom.run "fetchAndCachePlaceCalData"
        (Json.Encode.object
            [ ( "collection", Json.Encode.string collection )
            , ( "url", Json.Encode.string Constants.placecalApi )
            , ( "query", query )
            ]
        )
