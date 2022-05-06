# The Trans Dimension

## A [PlaceCal](https://placecal.org/) community site

Front-end for [The Trans Dimension](http://transdimension.uk/), an online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between [Gendered Intelligence](https://genderedintelligence.co.uk/) and [Geeks for Social Change](https://gfsc.studio/).

Funded by the [Comic Relief Tech for Good “Build” fund](https://techforgoodhub.co.uk/build-fund-2021). Read more about the project [here](https://gfsc.studio/2021/12/14/enter-trans-dimension.html).

-  Staging url: https//https://staging--transdimension.netlify.app/
-  Temp production URL (during alpha dev): https://transdimension.netlify.app/
-  Production URL (holding page currently): http://transdimension.uk/

[![Netlify Status](https://api.netlify.com/api/v1/badges/651caf38-e14c-44de-adc3-c772f47bab38/deploy-status)](https://app.netlify.com/sites/transdimension/deploys)


# Development

## Prerequisites

- [node](https://nodejs.org/)
- [nvm for macOS & Linux](https://github.com/nvm-sh/nvm) or [nvm for Windows](https://github.com/coreybutler/nvm-windows)

## Setup & install instructions

- make sure you are using the correct node version with `nvm use`
- install with `npm install`

## Build

- `npm start` to start a dev server on http://localhost:3000
- `npm build` generate a production build in `dist/`

## Formatting

We recommend integrating `elm-format@0.8.3` into your code editor, but if you don't...
- Please run `npm format` to format `.elm` files in `src` before committing code.

## Testing

We're using elm-test-rs(https://github.com/mpizenberg/elm-test-rs) to run [elm tests](https://package.elm-lang.org/packages/elm-explorations/test/latest/)

-  run tests with `npm test`

## Code & configs

### This site is built with `elm-pages`

- [Documentation site](https://elm-pages.com)
- [Elm Package docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/)
- [`elm-pages` blog](https://elm-pages.com/blog)

### What it's for

- `elm.json` for elm packages used for site
- `elm-tooling.json` for elm packages used for code
- `package.json` for node scripts and packages
- `package-lock.json` for current versions of node packages
- `.nvmrc` contains project node version
- `.netlify.toml` for deploy config
- `tests/*` contains test files
- `public/*` contains static files to be copied direct to build
- `src/*` contains app source files

### Content & Pages

- Pages are in `Page/` and automatic route based on file name
- Copy is not from a datasource (e.g. UI or SEO text) is in `Copy/Text.elm`
- We use `[cCc] to denote placeholder copy`
- We use `[fFf] to denote placeholder UI feature or section`

### Styling & layouts

- We are using [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css) for styling

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
-  don't forget to include tests if it's a new feature
-  ask questions & make plan

### Code review & merge

-  check the acceptance criteria have been met (with tests if appropriate)
-  add comments & questions
-  once approved, leave for the author to squash and merge
