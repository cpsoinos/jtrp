module Clover
  class Discount < CloverBase

    attr_accessor :approver,
                  :amount,
                  :percentage,
                  :name,
                  :discount,
                  :id

    def find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}/discounts", headers) do |response, request, result|
        begin
          case response.code
          when 200
            discounts = JSON.parse(response)["elements"]
            discounts.map { |d| new(d) }
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Airbrake.notify(e, { message: result.message,  order_id: order.id, response: response, result: result })
        end
      end
    end

  end
end
