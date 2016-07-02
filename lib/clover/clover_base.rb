module Clover
  class CloverBase

    def self.base_url
      "#{Rails.application.config.clover_api_url}/v3/merchants/#{ENV['CLOVER_MERCHANT_ID']}"
    end

    def self.headers
      {
        Authorization: "Bearer #{ENV['CLOVER_API_TOKEN']}",
        content_type: :json
      }
    end
  end
end
