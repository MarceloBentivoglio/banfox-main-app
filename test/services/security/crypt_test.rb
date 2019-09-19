require 'test_helper'

class Security::CryptTest < ActiveSupport::TestCase
  setup do
    @crypt = Security::Crypt.new('plain_data')
  end

  test '.encrypt' do
    encrypted_string = @crypt.encrypt

    assert_not_equal encrypted_string, "plain_data"
  end

  test '.decrypt' do
    encrypted_string = @crypt.encrypt
    decrypted_string = Security::Crypt.new(encrypted_string).decrypt

    assert_equal decrypted_string, 'plain_data'
  end
end
