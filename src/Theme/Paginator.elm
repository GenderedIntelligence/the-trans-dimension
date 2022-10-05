module Theme.Paginator exposing (scrollPagination)

import Browser.Dom exposing (Error, getViewportOf, setViewportOf)
import Task exposing (Task)


scrollPagination : Float -> Task Error ()
scrollPagination scrollXFloat =
    getViewportOf "scrollable"
        |> Task.andThen (\info -> scrollX scrollXFloat info.viewport.x)


scrollX : Float -> Float -> Task Error ()
scrollX scrollRemaining viewportXPosition =
    let
        pixelsLeftToMove =
            round (posOrNeg scrollRemaining * scrollRemaining)
    in
    if pixelsLeftToMove < 6 then
        getViewportOf "scrollable"
            |> Task.andThen (\_ -> setViewportOf "scrollable" (viewportXPosition + scrollRemaining) 0)

    else
        getViewportOf "scrollable"
            |> Task.andThen (\_ -> setViewportOf "scrollable" (viewportXPosition + posOrNeg scrollRemaining * 5) 0)
            |> Task.andThen (\_ -> scrollX (scrollRemaining - posOrNeg scrollRemaining * 5) (viewportXPosition + posOrNeg scrollRemaining * 5))


posOrNeg : Float -> Float
posOrNeg numToTest =
    toFloat
        (if numToTest > 0 then
            1

         else
            -1
        )
