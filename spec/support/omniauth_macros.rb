module OmniauthMacros
  def mock_auth_hash(provider)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      "provider" => provider.to_s,
      "uid" => "123",
      "info" => {
        "email" => "mockuser@gmail.com",
      },
      "credentials" => {
        "token" => "mock_token",
        "secret" => "mock_secret",
      },
    })
  end
end
