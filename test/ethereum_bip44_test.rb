require "test_helper"

class EthereumBip44Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EthereumBip44::VERSION
  end

  def test_it_can_create_a_new_wallet
    keychain = BTC::Keychain.new(seed: "secret seed")
    wallet = EthereumBip44::Wallet.new(keychain)
    puts wallet.get_address(0)
    assert_equal 42, wallet.get_address(0).length
    assert_equal 42, wallet.get_address(1).length
    assert_equal wallet.get_address(1), wallet.get_address(1)
  end

  def test_it_can_create_a_new_wallet_from_public_seed
    keychain = BTC::Keychain.new(seed: "secret seed")
    derived_pub_key = keychain.derived_keychain("m/44'/60'/0'/0").xpub

    # create the hd wallet
    wallet = EthereumBip44::Wallet.from_public_seed(derived_pub_key)
    puts wallet.get_address(0)
    assert_equal 42, wallet.get_address(0).length
    assert_equal 42, wallet.get_address(1).length
    assert_equal wallet.get_address(1), wallet.get_address(1)
  end

  def test_it_can_create_a_new_wallet_from_private_seed
    prv_keychain = BTC::Keychain.new(seed: "secret seed").xprv

    # create the hd wallet
    wallet = EthereumBip44::Wallet.from_private_seed(prv_keychain)
    puts wallet.get_address(0)
    assert_equal 42, wallet.get_address(0).length
    assert_equal 42, wallet.get_address(1).length
    assert_equal wallet.get_address(1), wallet.get_address(1)
  end
end
