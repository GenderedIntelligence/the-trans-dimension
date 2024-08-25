module Data.PlaceCal.Partners exposing (Address, Contact, Partner, ServiceArea, emptyPartner, eventPartnerFromId, partnerNameFromId, partnerNamesFromIds, partnersData)

import BackendTask
import BackendTask.Http
import Constants
import Data.PlaceCal.Events exposing (EventPartner)
import FatalError
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


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


partnersData : BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Http.Error } AllPartnersResponse
partnersData =
    BackendTask.Http.post Constants.placecalApi
        (BackendTask.Http.jsonBody allPartnersQuery)
        (BackendTask.Http.expectJson
            partnersDecoder
        )


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


partnersDecoder : Json.Decode.Decoder AllPartnersResponse
partnersDecoder =
    Json.Decode.succeed AllPartnersResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "partnersByTag" ] (Json.Decode.list decodePartner)


decodePartner : Json.Decode.Decoder Partner
decodePartner =
    Json.Decode.succeed Partner
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.optional "summary" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "description" Json.Decode.string
        |> Json.Decode.Pipeline.optional "url" (Json.Decode.map Just Json.Decode.string) Nothing
        |> Json.Decode.Pipeline.optional "contact" (Json.Decode.map Just contactDecoder) Nothing
        |> Json.Decode.Pipeline.optional "address" (Json.Decode.map Just addressDecoder) Nothing
        |> Json.Decode.Pipeline.required "areasServed" (Json.Decode.list serviceAreaDecoder)
        |> Json.Decode.Pipeline.optionalAt [ "address", "geo" ] (Json.Decode.map Just geoDecoder) Nothing
        |> Json.Decode.Pipeline.optional "logo" (Json.Decode.nullable Json.Decode.string) Nothing


geoDecoder : Json.Decode.Decoder Geo
geoDecoder =
    Json.Decode.succeed Geo
        |> Json.Decode.Pipeline.optional "latitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing
        |> Json.Decode.Pipeline.optional "longitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing


contactDecoder : Json.Decode.Decoder Contact
contactDecoder =
    Json.Decode.succeed Contact
        |> Json.Decode.Pipeline.optional "email" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "telephone" Json.Decode.string ""


addressDecoder : Json.Decode.Decoder Address
addressDecoder =
    Json.Decode.succeed Address
        |> Json.Decode.Pipeline.required "streetAddress" Json.Decode.string
        |> Json.Decode.Pipeline.required "addressRegion" Json.Decode.string
        |> Json.Decode.Pipeline.required "postalCode" Json.Decode.string


serviceAreaDecoder : Json.Decode.Decoder ServiceArea
serviceAreaDecoder =
    Json.Decode.succeed ServiceArea
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.optional "abbreviatedName"
            (Json.Decode.map Just Json.Decode.string)
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
