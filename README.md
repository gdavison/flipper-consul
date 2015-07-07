# Flipper Consul

A [Consul](https://www.consul.io) adapter for [Flipper](https://github.com/jnunemaker/flipper).

Uses [Diplomat](https://github.com/WeAreFarmGeek/diplomat) as the Consul client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flipper-consul'
```

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install flipper-consul

## Usage

```ruby
require 'flipper/adapters/consul'
client = Diplomat::Kv.new
adapter = Flipper::Adapters::Consul.new(client)
flipper = Flipper.new(adapter)
```

To avoid polluting the global key/value space, the Flipper data can (and should) be namespaced.

```ruby
require 'flipper/adapters/consul'
client = Diplomat::Kv.new
adapter = Flipper::Adapters::Consul.new(client, 'your/flipper/namespace')
flipper = Flipper.new(adapter)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/flipper-consul/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
