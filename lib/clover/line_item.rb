require 'rest-client'

module Clover
  class LineItem < Clover::CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}/line_items?expand=discounts", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response)["elements"])
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

  end
end
