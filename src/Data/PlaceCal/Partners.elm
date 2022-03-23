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
    , address : Maybe PartnerAddress
    }


type alias PartnerAddress =
    { postalCode : String }


emptyPartner : Partner
emptyPartner =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    , address = Just { postalCode = "" }
    }



----------------------------
-- DataSource query & decode
----------------------------


type alias AllPartnersResponse =
    { allPartners : List Partner }


partnersData : DataSource.DataSource AllPartnersResponse
partnersData =
    DataSource.Http.request (Pages.Secrets.succeed allPartnersPlaceCalRequest)
        partnersDecoder


allPartnersQuery : Json.Encode.Value
allPartnersQuery =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string """
                query { partnerConnection { edges { node
                { 
                  id
                  name
                  description
                  summary
                  address { postalCode }
                } } } }
          """
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
        |> OptimizedDecoder.Pipeline.optionalAt [ "node", "address" ] (OptimizedDecoder.map Just addressDecoder) Nothing


addressDecoder : OptimizedDecoder.Decoder PartnerAddress
addressDecoder =
    OptimizedDecoder.succeed PartnerAddress
        |> OptimizedDecoder.Pipeline.requiredAt [ "postalCode" ] OptimizedDecoder.string
