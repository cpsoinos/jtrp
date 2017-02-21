require 'rest-client'

module Clover
  class Order < CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{self.identifier(order)}?expand=discounts,lineItems,payType,payments", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Rollbar.error(e, result.message,  order_id: order.id, response: response, result: result)
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
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Rollbar.error(e, result.message,  response: response, result: result)
        end
      end
    end

    private

    def self.identifier(order)
      id = order.try(:remote_id)
      id ||= order
    end

  end
end
