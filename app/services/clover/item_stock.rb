module Clover
  class ItemStock < CloverBase

    attr_accessor :item,
                  :stockCount,
                  :quantity

    def self.find(item)
      RestClient.get("#{base_url}/item_stocks/#{item.remote_id}", headers) do |response, request, result|
        begin
          case response.code
          when 200
            new(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError
        end
      end
    end

    def self.update(item)
      RestClient.post("#{base_url}/item_stocks/#{item.remote_id}", { quantity: item.stock, stockCount: item.stock }.to_json, headers) do |response, request, result|
        begin
          case response.code
          when 200
            new(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError
        end
      end
    end

  end
end
