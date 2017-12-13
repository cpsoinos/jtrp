require 'rest-client'

module Clover
  class LineItem < CloverBase

    attr_accessor :id,
                  :orderRef,
                  :item,
                  :discounts,
                  :name,
                  :alternateName,
                  :price,
                  :itemCode,
                  :printed,
                  :createdTime,
                  :orderClientCreatedTime,
                  :exchanged,
                  :refunded,
                  :isRevenue

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}/line_items?expand=discounts,item", headers) do |response, request, result|
        begin
          case response.code
          when 200
            line_items = JSON.parse(response)["elements"]
            line_items.map { |li| new(li) }
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Raven.extra_context(message: result.message, order_id: order.id, response: response, result: result)
          Raven.capture_exception(e)
        end
      end
    end

  end
end
