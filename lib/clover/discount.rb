require 'rest-client'

module Clover
  class Discount < Clover::CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}/line_items?expand=discounts", headers) do |response, request, result|
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
          Rollbar.error(e, order_id: order.id)
        end
      end
    end

  end
end
