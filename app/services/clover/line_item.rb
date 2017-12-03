require 'rest-client'

module Clover
  class LineItem < CloverBase

    attr_accessor :id,
                  :orderRef,
                  :item,
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

    def initialize(attrs)
      attrs                          = attrs.deep_symbolize_keys!
      attrs[:price]                  = Money.new(attrs[:price])
      attrs[:createdTime]            = Time.at(attrs[:createdTime] / 1000)
      attrs[:orderClientCreatedTime] = Time.at(attrs[:orderClientCreatedTime] / 1000)
      attrs[:item]                   = Clover::Inventory.new(attrs[:item]) if attrs[:item]
      set_attributes(attrs)
    end

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
          # Rollbar.error(e, result.message,  order_id: order.id, response: response, result: result)
          Airbrake.notify(e, {message: result.message,  order_id: order.id, response: response, result: result})
        end
      end
    end

  end
end
