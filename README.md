# Crystalcent

[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://devops-israel.github.io/crystalcent/)
[![GitHub release](https://img.shields.io/github/release/devops-israel/crystalcent.svg)](https://github.com/devops-israel/crystalcent/releases)
[![Build Status](https://travis-ci.org/devops-israel/crystalcent.svg?branch=master)](https://travis-ci.org/devops-israel/crystalcent)


[crystalcent](https://github.com/devops-israel/crystalcent) is a [Centrifugo API](https://centrifugal.github.io/centrifugo/server/http_api/) wrapper writes with [Crystal](http://crystal-lang.org/) Language.

Inspired from [gitlab](https://github.com/icyleaf/gitlab.cr).

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  cent:
    github: devops-israel/crystalcent
```

2. Run `shards install`

## Usage

```crystal
require "cent"

# configuration
endpoint = "https://cent.example.com" # No tailing forward slash
api_key = "<api_key>"

# initialize a new client with user and password for basic auth
centrifugo_client = Cent.client(endpoint, api_key)
# => #<Cent::Client:0x101653f20 @endpoint="https://cent.example.com", @api_key="xxx">

# server health
centrifugo_client.available?
# true

centrifugo_client.publish("channel_x", {text: "value1"})
centrifugo_client.broadcast(["channel_x", "channel_y"], {"stam" => "data"})
centrifugo_client.unsubscribe("channel_x", "user_x")
centrifugo_client.disconnect("user_x")
centrifugo_client.presence("channel_x")
centrifugo_client.presence_stats("channel_x")
centrifugo_client.history("channel_x")
centrifugo_client.channels
centrifugo_client.info
```

## Implemented API

#### Completed

### API
- `POST /api` - Main API endpoint for all actions

#### Supported API calls:

* publish
* broadcast
* unsubscribe
* disconnect
* presence
* presence_stats
* history
* channels
* info

### Server Health
- `GET /health` - returns 200 OK (you need to configure Centrifugo to allow (health endpoint)[https://centrifugal.github.io/centrifugo/server/configuration/#healthcheck-endpoint])

## Development

### Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop)

### Commands

* From inside the root of the project run `docker-compose up`
* The container is configured to run tests every time a file is changed so just start developing.

## Contributing

1. Fork it (https://github.com/devops-israel/crystalcent/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Josh Dvir](https://github.com/joshdvir) - creator and maintainer

## License

[MIT License](https://github.com/devops-israel/crystalcent/blob/master/LICENSE) © devops-israel