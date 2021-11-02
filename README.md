# Cosmos

![Logo](assets/logos/128.png)

With Cosmos, I aim to provide a platform to collect data from connected devices
and act on them defining a set of rules.

> *Name origin*: [Cosmos](https://en.wikipedia.org/wiki/Cosmos) is used at times
when the universe is regarded as a complex and orderly system or entity;
the opposite of chaos.

[![Unit Tests](https://github.com/cosmos-st/back-end/workflows/Build/badge.svg?branch=release-candidate)](https://github.com/cosmos-st/back-end/actions?query=workflow%3ABuild)
[![Coverage Status](https://codecov.io/github/cosmos-st/back-end/coverage.svg?branch=release-candidate)](https://codecov.io/gh/cosmos-st/back-end/branch/release-candidate)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)

Quick links

- [**Explore the docs**](/docs)
- [Report a defect](https://github.com/fortizpenaloza/cosmos/issues/new?labels=Type%3A+Bug)
- [Request feature](https://github.com/fortizpenaloza/cosmos/issues/new?labels=Type%3A+Development)

## License

- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

## Quick Start

### Using a docker image

A Docker image is pushed to [Docker Hub](https://hub.docker.com) every time
CI runs successfully.

In order to use it you must pull the latest docker image by typing into
your CLI
`docker pull fortizpenaloza/cosmos`

and then start it typing
`docker run -v logs:/opt/cosmos/logs --rm -p 8090:8090 fortizpenaloza/cosmos`

### Using an Pharo image

- Download the latest [Pharo 32](https://get.pharo.org/) or [64 bits VM](https://get.pharo.org/64/).
- Download a ready to use image from the [release page](http://github.com/iot-uca/back-end/releases/latest)
- Explore the [documentation](docs/).

## Installation

To load the project in a Pharo image, or declare it as a dependency of your own
project follow this [instructions](docs/Installation.md)

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)
