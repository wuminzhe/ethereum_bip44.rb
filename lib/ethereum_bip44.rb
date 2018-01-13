require "ethereum_bip44/version"
require 'ecdsa'
require 'digest/sha3'
require 'rlp'
require 'money-tree'
require 'bip_mnemonic'
require 'ethereum_bip44/utils'

module EthereumBip44

  # "44'",  # bip 44
  # "60'",  # coin
  # "0'",   # wallet
  # "0"     # 0 - public, 1 = private
  # "0"     # index
  class Wallet

    def self.create_from_mnemonic(mnemonic, wallet_index)
      seed = BipMnemonic.to_seed(mnemonic: mnemonic) # 2. 该助记词使用 PBKDF2 转化为种子（参见 BIP39）
      EthereumBip44::Wallet.new(seed, wallet_index)
    end
    
    def initialize(seed, wallet_index)
      master = MoneyTree::Master.new(seed_hex: seed) # 3. 种子用于使用 HMAC-SHA512 生成根私钥（参见 BIP32）
      @wallet_node = master.node_for_path("m/44'/60'/#{wallet_index}'") # 4. 从该根私钥，导出子私钥（参见 BIP32），其中节点布局由BIP44设置
    end

    def get_address(index)
      node = @wallet_node.node_for_path("M/0/#{index}")

      # from bitcoin public key to ethereum public key
      group = ECDSA::Group::Secp256k1
      public_key = ECDSA::Format::PointOctetString.decode(node.public_key.to_bytes, group) # a point
      ethereum_public = public_key.x.to_s(16) + public_key.y.to_s(16)

      # from ethereum public key to ethereum address
      bytes = EthereumBip44::Utils.hex_to_bin(ethereum_public)
      address_bytes = Digest::SHA3.new(256).digest(bytes)[-20..-1]
      address = EthereumBip44::Utils.bin_to_hex(address_bytes)
      EthereumBip44::Utils.prefix_hex(address)
    end

  end

end
