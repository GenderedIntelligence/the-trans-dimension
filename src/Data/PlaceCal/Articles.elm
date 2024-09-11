module Data.PlaceCal.Articles exposing (Article, articleFromSlug, articlesData, emptyArticle, replacePartnerIdWithName)

import BackendTask
import BackendTask.Http
import Constants
import Data.PlaceCal.Partners
import FatalError
import Helpers.TransDate
import Helpers.TransRoutes
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Time


type alias Article =
    { title : String
    , body : String
    , publishedDatetime : Time.Posix
    , partnerIds : List String
    , maybeImage : Maybe String
    }


emptyArticle : Article
emptyArticle =
    { title = ""
    , body = ""
    , publishedDatetime = Time.millisToPosix 0
    , partnerIds = []
    , maybeImage = Nothing
    }



----------------------------
-- BackendTask query & decode
----------------------------


articlesData : BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Http.Error } AllArticlesResponse
articlesData =
    BackendTask.Http.post Constants.placecalApi
        (BackendTask.Http.jsonBody allArticlesQuery)
        (BackendTask.Http.expectJson
            articlesDecoder
        )


allArticlesQuery : Json.Encode.Value
allArticlesQuery =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string """
            query { articleConnection { edges {
                node {
                  articleBody
                  datePublished
                  headline
                  providers { id }
                  image
            } } } }
            """
          )
        ]


articlesDecoder : Json.Decode.Decoder AllArticlesResponse
articlesDecoder =
    Json.Decode.succeed AllArticlesResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "articleConnection", "edges" ] (Json.Decode.list decode)


decode : Json.Decode.Decoder Article
decode =
    Json.Decode.succeed Article
        |> Json.Decode.Pipeline.requiredAt [ "node", "headline" ]
            Json.Decode.string
        |> Json.Decode.Pipeline.requiredAt [ "node", "articleBody" ]
            Json.Decode.string
        |> Json.Decode.Pipeline.requiredAt [ "node", "datePublished" ]
            Helpers.TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.requiredAt [ "node", "providers" ]
            (Json.Decode.list partnerIdDecoder)
        |> Json.Decode.Pipeline.optionalAt [ "node", "image" ]
            (Json.Decode.nullable Json.Decode.string)
            Nothing


partnerIdDecoder : Json.Decode.Decoder String
partnerIdDecoder =
    Json.Decode.succeed ProviderId
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.map (\providerItem -> providerItem.id)


type alias ProviderId =
    { id : String }


type alias AllArticlesResponse =
    { allArticles : List Article }


replacePartnerIdWithName : List Article -> List Data.PlaceCal.Partners.Partner -> List Article
replacePartnerIdWithName articleData partnerData =
    List.map
        (\article ->
            { article | partnerIds = Data.PlaceCal.Partners.partnerNamesFromIds partnerData article.partnerIds }
        )
        articleData


articleFromSlug : String -> List Article -> List Data.PlaceCal.Partners.Partner -> Article
articleFromSlug slug allArticles allPartners =
    List.filter
        (\article -> Helpers.TransRoutes.stringToSlug article.title == slug)
        (replacePartnerIdWithName allArticles allPartners)
        |> List.head
        |> Maybe.withDefault emptyArticle
