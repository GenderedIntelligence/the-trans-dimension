module Data.PlaceCal.Partners exposing (Address, Contact, Partner, ServiceArea, emptyPartner, partnerNamesFromIds, partnersData)

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
    , maybeUrl : Maybe String
    , contactDetails : Contact
    , maybeAddress : Maybe Address
    , areasServed : List ServiceArea
    }


type alias Address =
    { streetAddress : String
    , addressRegion : String
    , postalCode : String
    }


type alias Contact =
    { email : String
    , telephone : String
    }


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
    , maybeUrl = Nothing
    , contactDetails = { email = "", telephone = "" }
    , maybeAddress = Nothing
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
                  contact { email, telephone }
                  url
                  address { streetAddress, postalCode, addressRegion }
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
        |> OptimizedDecoder.Pipeline.optional "url" (OptimizedDecoder.map Just OptimizedDecoder.string) Nothing
        |> OptimizedDecoder.Pipeline.required "contact" contactDecoder
        |> OptimizedDecoder.Pipeline.optional "address" (OptimizedDecoder.map Just addressDecoder) Nothing
        |> OptimizedDecoder.Pipeline.required "areasServed" (OptimizedDecoder.list serviceAreaDecoder)


contactDecoder : OptimizedDecoder.Decoder Contact
contactDecoder =
    OptimizedDecoder.succeed Contact
        |> OptimizedDecoder.Pipeline.required "email" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "telephone" OptimizedDecoder.string


addressDecoder : OptimizedDecoder.Decoder Address
addressDecoder =
    OptimizedDecoder.succeed Address
        |> OptimizedDecoder.Pipeline.required "streetAddress" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "addressRegion" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.required "postalCode" OptimizedDecoder.string


serviceAreaDecoder : OptimizedDecoder.Decoder ServiceArea
serviceAreaDecoder =
    OptimizedDecoder.succeed ServiceArea
        |> OptimizedDecoder.Pipeline.required "name" OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.optional "abbreviatedName"
            (OptimizedDecoder.map Just OptimizedDecoder.string)
            Nothing


partnerNamesFromIds : List Partner -> List String -> List String
partnerNamesFromIds partnerList idList =
    -- If the partner isn't in our sites partners, it won't be in the list
    List.filter (\partner -> List.member partner.id idList) partnerList
        |> List.map (\partner -> partner.name)
