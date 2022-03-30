module Data.PlaceCal.Partners exposing (Address, Partner, ServiceArea, emptyPartner, partnersData)

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
    , address : Maybe Address
    , areasServed : List ServiceArea
    }


type alias Address =
    { postalCode : String }


type alias ServiceArea =
    { name : String
    , abbreviatedName : Maybe String
    }


emptyPartner : Partner
emptyPartner =
    { id = ""
    , name = ""
    , summary = ""
    , description = ""
    , address = Nothing
    , areasServed = []
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
                query { partnersByTag(tagId: 3) {
                  id
                  name
                  description
                  summary
                  address { postalCode }
                  areasServed { name abbreviatedName }
                } }
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
        |> OptimizedDecoder.Pipeline.requiredAt [ "data", "partnersByTag" ] (OptimizedDecoder.list decodePartner)


decodePartner : OptimizedDecoder.Decoder Partner
decodePartner =
    OptimizedDecoder.succeed Partner
        |> OptimizedDecoder.Pipeline.required "id" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "name" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optional "summary" OptimizedDecoder.string ""
        |> OptimizedDecoder.Pipeline.required "description" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optional "address" (OptimizedDecoder.map Just addressDecoder) Nothing
        |> OptimizedDecoder.Pipeline.required "areasServed"
            (OptimizedDecoder.list serviceAreaDecoder)


addressDecoder : OptimizedDecoder.Decoder Address
addressDecoder =
    OptimizedDecoder.succeed Address
        |> OptimizedDecoder.Pipeline.required "postalCode" OptimizedDecoder.string


serviceAreaDecoder : OptimizedDecoder.Decoder ServiceArea
serviceAreaDecoder =
    OptimizedDecoder.succeed ServiceArea
        |> OptimizedDecoder.Pipeline.required "name" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optional "abbreviatedName"
            (OptimizedDecoder.map Just OptimizedDecoder.string)
            Nothing
