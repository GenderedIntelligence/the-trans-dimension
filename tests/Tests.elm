module Tests exposing (..)

import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "True test"
        [ test "True is true" <|
            \_ ->
                True
                    |> Expect.equal True
        ]
