module Data.PlaceCal.Partners exposing (Partner, emptyPartner, partnersData)

import Api
import DataSource
import DataSource.Http
import Json.Encode
import OptimizedDecoder
import OptimizedDecoder.Pipeline
import Pages.Secrets


type alias Partner =
    { id : String
    , name : String
    , summary : String
    , description : String
    }


emptyPartner : Partner
emptyPartner =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    }



----------------------------
-- DataSource query & decode
----------------------------


partnersData : DataSource.DataSource AllPartnersResponse
partnersData =
    DataSource.Http.request (Pages.Secrets.succeed allPartnersPlaceCalRequest)
        partnersDecoder


allPartnersQuery : Json.Encode.Value
allPartnersQuery =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string "query { partnerConnection { edges { node {id name description summary } } } }"
          )
        ]


allPartnersPlaceCalRequest : DataSource.Http.RequestDetails
allPartnersPlaceCalRequest =
    { url = Api.placeCalApiUrl
    , method = "POST"
    , headers = []
    , body = DataSource.Http.jsonBody allPartnersQuery
    }


partnersDecoder : OptimizedDecoder.Decoder AllPartnersResponse
partnersDecoder =
    OptimizedDecoder.succeed AllPartnersResponse
        |> OptimizedDecoder.Pipeline.requiredAt [ "data", "partnerConnection", "edges" ] (OptimizedDecoder.list decodePartner)


decodePartner : OptimizedDecoder.Decoder Partner
decodePartner =
    OptimizedDecoder.succeed Partner
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "id" ] OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "name" ] OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optionalAt [ "node", "summary" ] OptimizedDecoder.string ""
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "description" ] OptimizedDecoder.string


type alias AllPartnersResponse =
    { allPartners : List Partner }
