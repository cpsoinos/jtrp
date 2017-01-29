require 'rest-client'

module Clover
  class Order < Clover::CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}?expand=lineItems,discounts", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError
          end
        rescue CloverError => e
          Rollbar.error(e, order_id: order.id, response: response, result: result)
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/orders?expand=lineItems,discounts", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response)["elements"])
          else
            raise CloverError
          end
        rescue CloverError => e
          Rollbar.error(e, response: response, result: result)
        end
      end
    end

  end
end
