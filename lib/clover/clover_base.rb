module Clover
  class CloverBase

    def self.base_url
      "#{ENV['CLOVER_API_URL']}/v3/merchants/#{ENV['CLOVER_MERCHANT_ID']}"
    end

    def self.headers
      {
        Authorization: "Bearer #{auth_token}",
        content_type: :json
      }
    end

    def self.auth_token
      @_auth_token ||= begin
        Admin.first.oauth_accounts.clover.first.try(:access_token) ||
          ENV['CLOVER_API_TOKEN']
      end
    end

  end
end
