[![tests](https://github.com/ddev/ddev-spidergram/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-spidergram/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

# ddev-spidergram <!-- omit in toc -->

* [What is ddev-spidergram?](#what-is-ddev-spidergram)
* [Installation](#installation)
* [Basic usage](#basic-usage)
* [Behind the scenes](#behind-the-scenes)
* [TODO](#todo)
* [Contributing](#contributing)

## What is ddev-spidergram?
This repository provides an addon to use [@Spidergram](https://github.com/autogram-is/spidergram) within [DDEV](https://ddev.readthedocs.io/).
>Spidergram is a customizable toolkit for crawling and analyzing complicated web properties.
> While it can be used to crawl any website, we (the folks at [Autogram](https://autogram.is/)) designed it specifically for "ten websites in a trench coat" scenarios where a web property encompasses multiple CMSs, multiple domains, and multiple design systems, maintained by multiple teams.

## Installation
0. Make sure [Docker](https://ddev.readthedocs.io/en/stable/users/install/docker-installation/) and [DDEV](https://ddev.readthedocs.io/en/stable/users/install/ddev-installation/) are installed.

1. Create a new directory and go into it. For simplicity reasons I am using the name `spidergram` for this guide. You are able to use any other name here.
```
mkdir spidergram && cd spidergram
```

2. Initialize the DDEV project using the suggested defaults. By using the defaults the project name will be equal to the directory name.
```
ddev config
```

3. Download the `ddev-spidergram`-addon.
```
ddev get rpkoller/ddev-spidergram
```

4. Start DDEV and wait a few minutes until the DDEV and ArangoDB images, Spidergram, as well as Playwright are downloaded and installed.
```
ddev start
```

## Basic usage
1. Run an initial status check that everything is set up correctly.
```
ddev spidergram status
```

The output should look like that:

```
$> ddev spidergram status

SPIDERGRAM CONFIG
Config file: /var/www/html/spidergram.config.yaml

ARANGODB
Status:   online
URL:      http://spidergram.ddev.site:8529
Database: db
```

2. Crawl and analyze your first site.
```
ddev spidergram go https://ddev.com
```

3. The ArangoDB backend could be reached via the URL shown for `ddev spidergram status`. You simply have to copy http://spidergram.ddev.site:8529 into your browser.
4. For more details see the [Spidergram documentation](https://github.com/autogram-is/spidergram/tree/main/docs). All configuration changes are applied to the `spidergram.config.yaml` file.

## Behind the scenes
1. Adds a docker-compose file (`docker-compose.arangodb.yaml`) for ArangoDB.
1. Adds a dockerfile (`Dockerfile.spidergram`) to the web-build folder. It runs a `npm install --global spidergram`, `npx playwright install`, and a `npx playwright install-deps` when the addon is installed.
1. Adds a `spidergram` web command. You only have to call for example `ddev spidergram status` instead of `ddev exec spidergram status`.
1. Adds a `spidergram.config.yaml` to the project root. The json with the exact file name is mandatory for Spidergram to run. In a `post-start`-hook
it is ensured that the URL set in the config.json is in line with the overall project settings. The project name based on $DDEV_PROJECT and the TLD based on $DDEV_TLD gets replaced in the URL by a regex.
1. The `config.spidergram.yaml` file ensures that the Node version is set to version 18.

## TODO
- [ ] Figure out the best approach how to upgrade Spidergram and it's dependencies for an already existing Spidergram DDEV instance and update the README accordingly (_I have to wait for the next Spidergram release being able to test that_).
- [ ] Expand the number of available settings in the `spidergram.config.yaml`. At the moment I am only using the default values from an old template found at https://github.com/autogram-is/create-spidergram/tree/main/templates.

## Contributing
Any feedback in regard to bugs and potential improvements is welcome.

**Contributed and maintained by [@rpkoller](https://github.com/rpkoller) based on the original [ddev-addon-template](https://github.com/ddev/ddev-addon-template)**