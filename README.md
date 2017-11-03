# EthereumBip44 for ruby

A ruby library to generate Ethereum addresses from a hierarchical deterministic wallet according to the [BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) standard.

Internally it uses [btcruby](https://github.com/oleganza/btcruby) for the deterministic private and public keys which allows to use many additional features like deriving Ethereum address from mnemonic backups (BIP32).

This library is inspired by the js library [coinme/ethereum-bip44](https://github.com/coinme/ethereum-bip44), I followed its design.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ethereum_bip44'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ethereum_bip44

## Usage

See test

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wuminzhe/ethereum_bip44. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

