require "ethereum_bip44/version"
require 'btcruby'
require 'ecdsa'
require 'digest/sha3'
require 'rlp'
require 'ethereum_bip44/utils'

module EthereumBip44
  class Wallet
    def self.from_public_seed(seed)
      EthereumBip44::Wallet.new(BTC::Keychain.new(xpub: seed))
    end

    def self.from_private_seed(seed)
      EthereumBip44::Wallet.new(BTC::Keychain.new(xprv: seed))
    end

    def initialize(keychain)
      @parts = [
          "44'",  # bip 44
          "60'",  # coin
          "0'",   # wallet
          "0"     # 0 - public, 1 = private
                  # index
      ]
      @keychain = keychain
    end

    def derive(path)
      @keychain.derived_keychain(path)
    end


    def get_address(index)
      parts = @parts[@keychain.depth..-1]
      path = 'm/' + (!parts.empty? ? parts.join('/') + '/' : '') + index.to_s
      derived = @keychain.derived_keychain(path)
      public_key_string = derived.key.public_key
      group = ECDSA::Group::Secp256k1
      public_key = ECDSA::Format::PointOctetString.decode(public_key_string, group) # a point
      ethereum_public = public_key.x.to_s(16) + public_key.y.to_s(16)

      bytes = EthereumBip44.hex_to_bin(ethereum_public)
      address_bytes = Digest::SHA3.new(256).digest(bytes)[-20..-1]

      address = EthereumBip44.bin_to_hex(address_bytes)
      EthereumBip44.prefix_hex(address)
    end
  end
end
