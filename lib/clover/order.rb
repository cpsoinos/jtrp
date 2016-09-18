require 'rest-client'

module Clover
  class Order < Clover::CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}?expand=lineItems", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response))
        when 404
          nil
        else
          raise 'unable to find order - ' + JSON.parse(response)['message'].join('; ')
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/orders?expand=lineItems", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response)["elements"])
        else
          raise 'unable to get all inventory orders - ' + JSON.parse(response)['message'].join('; ')
        end
      end
    end

  end
end
