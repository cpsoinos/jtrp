require 'rest-client'

module Clover
  class Order < CloverBase

    attr_accessor :href,
                  :id,
                  :currency,
                  :employee,
                  :total,
                  :taxRemoved,
                  :isVat,
                  :state,
                  :manualTransaction,
                  :groupLineItems,
                  :testMode,
                  :payments,
                  :payType,
                  :createdTime,
                  :clientCreatedTime,
                  :modifiedTime,
                  :lineItems,
                  :discounts,
                  :device

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{self.identifier(order)}?expand=discounts,lineItems,payType,payments,lineItems.discounts,lineItems.item", headers) do |response, request, result|
        begin
          case response.code
          when 200
            new(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Airbrake.notify(e, {message: result.message,  order_id: order.id, response: response, result: result})
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/orders?expand=lineItems,discounts", headers) do |response, request, result|
        begin
          case response.code
          when 200
            orders = JSON.parse(response)["elements"]
            orders.map { |o| new(o) }
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Airbrake.notify(e, {message: result.message,  response: response, result: result})
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
