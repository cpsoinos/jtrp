require 'rest-client'

module Clover
  class LineItem < Clover::CloverBase

    def self.find(order)
      RestClient.get("#{base_url}/orders/#{order.remote_id}/line_items?expand=item", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response))
        when 404
          nil
        else
          raise 'unable to find line item - ' + JSON.parse(response)['message']
        end
      end
    end

  end
end
