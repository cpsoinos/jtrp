module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:clover] = OmniAuth::AuthHash.new({
      'provider' => 'clover',
      'uid' => '123545',
      'info' => {
        'name' => 'john doe',
        'first_name' => 'john',
        'last_name' => 'doe',
        'email' => 'john@doe.com',
        'urls' => {
          'Clover' => 'http://test.test/public_profile'
        }
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      },
      'extra' => {
        'raw_info' => '{"json":"data"}'
      }
    })
  end
end
