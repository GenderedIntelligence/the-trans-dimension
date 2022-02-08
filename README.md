# The Trans Dimension

## A [PlaceCal](https://placecal.org/) community site

Front-end for [The Trans Dimension](http://transdimension.uk/), an online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between [Gendered Intelligence](https://genderedintelligence.co.uk/) and [Geeks for Social Change](https://gfsc.studio/).

Funded by the [Comic Relief Tech for Good “Build” fund](https://techforgoodhub.co.uk/build-fund-2021). Read more about the project [here](https://gfsc.studio/2021/12/14/enter-trans-dimension.html).

-  Development URL: https://transdimension.netlify.app/
-  Production URL (holding page currently): http://transdimension.uk/

# Development

## Prerequisites

## Setup & install instructions

## Testing

We're using elm-test-rs(https://github.com/mpizenberg/elm-test-rs) to run [elm tests](https://github.com/elm-explorations/test/)

-  run tests with `npm test`

## Deployment

Deploys to Netlify

-  code is tested and linted automatically before deploy
-  when a pull request is created, a preview site is deployed
-  when a pull request is merged into `main`, the prodtion site is deployed

## Development workflow

### Adding issues

-  add effort & value labels (if you know enough about it)
-  put the issue in a milestone (if it is part of a current epic)

### Working on issue

-  assign it to yourself before starting work
-  make a branch that includes the issue type (fix/feat/chore etc & number)
-  make sure you understand the acceptance criteria
-  ask questions & make plan

### Code review & merge

-  check the acceptance criteria have been met
-  add comments & questions
-  once approved, leave for the author to squash and merge
