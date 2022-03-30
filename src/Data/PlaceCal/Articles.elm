module Data.PlaceCal.Articles exposing (Article, articlesData, emptyArticle)

import Api
import DataSource
import DataSource.Http
import Helpers.TransDate as TransDate
import Json.Encode
import OptimizedDecoder
import OptimizedDecoder.Pipeline
import Pages.Secrets
import Time


type alias Article =
    { title : String
    , body : String
    , publishedDatetime : Time.Posix
    , partnerId : String
    }


emptyArticle : Article
emptyArticle =
    { title = ""
    , body = ""
    , publishedDatetime = Time.millisToPosix 0
    , partnerId = ""
    }



----------------------------
-- DataSource query & decode
----------------------------


articlesData : DataSource.DataSource AllArticlesResponse
articlesData =
    DataSource.Http.request (Pages.Secrets.succeed allArticlesPlaceCalRequest)
        articlesDecoder


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
            } } } }
            """
          )
        ]


allArticlesPlaceCalRequest : DataSource.Http.RequestDetails
allArticlesPlaceCalRequest =
    { url = Api.placeCalApiUrl
    , method = "POST"
    , headers = []
    , body = DataSource.Http.jsonBody allArticlesQuery
    }


articlesDecoder : OptimizedDecoder.Decoder AllArticlesResponse
articlesDecoder =
    OptimizedDecoder.succeed AllArticlesResponse
        |> OptimizedDecoder.Pipeline.requiredAt [ "data", "articleConnection", "edges" ] (OptimizedDecoder.list decode)


decode : OptimizedDecoder.Decoder Article
decode =
    OptimizedDecoder.succeed Article
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "headline" ]
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "articleBody" ]
            OptimizedDecoder.string
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "datePublished" ]
            TransDate.isoDateStringDecoder
        |> OptimizedDecoder.Pipeline.requiredAt [ "node", "providers", "id" ]
            OptimizedDecoder.string


type alias AllArticlesResponse =
    { allArticles : List Article }
