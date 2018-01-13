module EthereumBip44

  # "44'",  # bip 44
  # "60'",  # coin, 0': bitcoin, 60': ethereum
  # "0'",   # wallet
  # "0"     # 0 - public, 1 = private
  # "0"     # index
  class Wallet
    include EthereumBip44::Bitcoin
    include EthereumBip44::Ethereum

    def self.from_seed(seed, path)
      master = MoneyTree::Master.new(seed_hex: seed) # 3. 种子用于使用 HMAC-SHA512 生成根私钥（参见 BIP32）
      wallet_node = master.node_for_path(path) # 4. 从该根私钥，导出子私钥（参见 BIP32），其中节点布局由BIP44设置
      Wallet.new(wallet_node)
    end

    def self.from_mnemonic(mnemonic, path)
      seed = BipMnemonic.to_seed(mnemonic: mnemonic) # 2. 该助记词使用 PBKDF2 转化为种子（参见 BIP39）
      Wallet.from_seed(seed, path)
    end
    
    def self.from_xpub(xpub)
      wallet_node = MoneyTree::Node.from_bip32(xpub)
      Wallet.new(wallet_node)
    end

    def xpub
      @wallet_node.to_bip32
    end

    def xprv
      @wallet_node.to_bip32(:private)
    end

    private

    def initialize(wallet_node)
      @wallet_node = wallet_node
    end

  end

end
