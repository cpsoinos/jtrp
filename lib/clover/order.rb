require 'rest-client'

module Clover
  class Order < Clover::CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}?expand=lineItems,discounts", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response))
        when 404
          nil
        else
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, item_id: item.id, error: JSON.parse(response))
      raise e
    end

    def self.all
      RestClient.get("#{base_url}/orders?expand=lineItems,discounts", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response)["elements"])
        else
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, error: JSON.parse(response))
      raise e
    end

  end
end
