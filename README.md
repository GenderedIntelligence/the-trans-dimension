# The Trans Dimension

## A [PlaceCal](https://placecal.org/) community site

Front-end for [The Trans Dimension](http://transdimension.uk/), an online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between [Gendered Intelligence](https://genderedintelligence.co.uk/) and [Geeks for Social Change](https://gfsc.studio/).

Funded by the [Comic Relief Tech for Good “Build” fund](https://techforgoodhub.co.uk/build-fund-2021). Read more about the project [here](https://gfsc.studio/2021/12/14/enter-trans-dimension.html).

-  Staging url: https://transdimension.pages.dev
-  Production URL (holding page currently): http://transdimension.uk/

# Development

## Prerequisites

- [node](https://nodejs.org/)
- [nvm for macOS & Linux](https://github.com/nvm-sh/nvm) or [nvm for Windows](https://github.com/coreybutler/nvm-windows)

## Setup & install instructions

- make sure you are using the correct node version with `nvm use`
- install with `npm install`

Make sure you copy `.env.example` over into `.env` and edit as appropriate! This must be done before any of the following will work as it generates `src/Constants.elm` which is used in a number of places in the code.

## Build

- `npm start` to start a dev server on http://localhost:3000
- `npm run build` generate a production build in `dist/`

## Formatting

We recommend integrating `elm-format@0.8.3` into your code editor, but if you don't...
- Please run `npm run format` to format `.elm` files in `src` before committing code.

## Testing

We're using [elm-test-rs](https://github.com/mpizenberg/elm-test-rs) to run [elm tests](https://package.elm-lang.org/packages/elm-explorations/test/latest/). It is required to run either `npm start` (quickest) or `npm build` at least once in the project before tests will work.

- run tests with `npm test`

## Code & configs

### This site is built with `elm-pages`

- [Documentation site](https://elm-pages.com)
- [Elm Package docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/)
- [`elm-pages` blog](https://elm-pages.com/blog)

### What it's for

- `elm.json` for elm packages used for site
- `elm-tooling.json` for elm packages used for code
- `.env` is used to generate `src/Constants.elm` for elm-pages
- `.nvmrc` contains project node version
- `package.json` for node scripts and packages
- `package-lock.json` for current versions of node packages
- `public/*` contains static files to be copied direct to build
- `src/*` contains app source files
- `tests/*` contains test files

### Content & Pages

- Pages are in `Page/` and automatic route based on file name
- Copy is not from a datasource (e.g. UI or SEO text) is in `Copy/Text.elm`
- We use `[cCc] to denote placeholder copy`
- We use `[fFf] to denote placeholder UI feature or section`

### Styling & layouts

- We are using [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css) for styling

## Deployment

Deploys to Cloudflare Pages

-  code is tested and linted automatically before deploy
-  when a pull request is created, a preview site is deployed
-  when a pull request is merged into `main`, the production site is deployed

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

## License

Source code is released under the [Hippocratic License](https://firstdonoharm.dev/version/3/0/license/).

Graphic design by [Studio Squid](https://studiosquid.co.uk/) and © Gendered Intelligence 2022.

Illustrations © [Harry Woodgate](https://www.harrywoodgate.com/) 2022.

## Contributing

We welcome new contributors but strongly recommend you have a chat with us in [Geeks for Social Change's Discord server](http://discord.gfsc.studio) and say hi before you do. We will be happy to onboard you properly before you get stuck in.

## Donations

If you'd like to support development, please consider sending us a one-off or regular donation on Ko-fi.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M43THUM)
