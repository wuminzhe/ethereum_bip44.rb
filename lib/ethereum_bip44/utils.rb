module EthereumBip44
  module Utils
    def self.hex_to_bin(string)
      RLP::Utils.decode_hex string
    end

    def self.bin_to_hex(string)
      RLP::Utils.encode_hex string
    end

    def self.prefix_hex(hex)
      hex.match(/\A0x/) ? hex : "0x#{hex}"
    end
  end
end
