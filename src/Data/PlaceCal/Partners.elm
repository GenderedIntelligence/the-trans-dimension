module Data.PlaceCal.Partners exposing (Address, Contact, Partner, ServiceArea, emptyPartner, eventPartnerFromId, partnerNameFromId, partnerNamesFromIds, partnersData)

import Api
import Data.PlaceCal.Events exposing (EventPartner)
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
    , maybeContactDetails : Maybe Contact
    , maybeAddress : Maybe Address
    , areasServed : List ServiceArea
    , maybeGeo : Maybe Geo
    , maybeLogo : Maybe String
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


type alias Geo =
    -- Bug: We expect if there is a postcode in the address, these exist.
    -- But, in practice, sometimes they don't see:
    -- https://github.com/geeksforsocialchange/PlaceCal/issues/1639
    { latitude : Maybe String
    , longitude : Maybe String
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
    , maybeContactDetails = Nothing
    , maybeAddress = Nothing
    , areasServed = []
    , maybeGeo = Nothing
    , maybeLogo = Nothing
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
                  address { streetAddress, postalCode, addressRegion, geo { latitude, longitude } }
                  areasServed { name abbreviatedName }
                  logo
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
        |> OptimizedDecoder.Pipeline.optional "contact" (OptimizedDecoder.map Just contactDecoder) Nothing
        |> OptimizedDecoder.Pipeline.optional "address" (OptimizedDecoder.map Just addressDecoder) Nothing
        |> OptimizedDecoder.Pipeline.required "areasServed" (OptimizedDecoder.list serviceAreaDecoder)
        |> OptimizedDecoder.Pipeline.optionalAt [ "address", "geo" ] (OptimizedDecoder.map Just geoDecoder) Nothing
        |> OptimizedDecoder.Pipeline.optional "logo" (OptimizedDecoder.nullable OptimizedDecoder.string) Nothing


geoDecoder : OptimizedDecoder.Decoder Geo
geoDecoder =
    OptimizedDecoder.succeed Geo
        |> OptimizedDecoder.Pipeline.optional "latitude"
            (OptimizedDecoder.nullable OptimizedDecoder.string)
            Nothing
        |> OptimizedDecoder.Pipeline.optional "longitude"
            (OptimizedDecoder.nullable OptimizedDecoder.string)
            Nothing


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


partnerNameFromId : List Partner -> String -> Maybe String
partnerNameFromId partnerList id =
    List.filter (\partner -> partner.id == id) partnerList
        |> List.map (\partner -> partner.name)
        |> List.head


partnerNamesFromIds : List Partner -> List String -> List String
partnerNamesFromIds partnerList idList =
    -- If the partner isn't in our sites partners, it won't be in the list
    List.filter (\partner -> List.member partner.id idList) partnerList
        |> List.map (\partner -> partner.name)


eventPartnerFromId : List Partner -> String -> EventPartner
eventPartnerFromId partnerList partnerId =
    List.filter (\partner -> partner.id == partnerId) partnerList
        |> List.map
            (\partner ->
                { name = Just partner.name
                , maybeContactDetails = partner.maybeContactDetails
                , id = partner.id
                , maybeUrl = partner.maybeUrl
                }
            )
        |> List.head
        |> Maybe.withDefault { name = Nothing, maybeContactDetails = Nothing, maybeUrl = Nothing, id = partnerId }
