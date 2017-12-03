require 'rest-client'

module Clover
  class Inventory < CloverBase

    attr_accessor :id,
                  :hidden,
                  :name,
                  :alternateName,
                  :sku,
                  :code,
                  :cost,
                  :price,
                  :priceType,
                  :defaultTaxRates,
                  :isRevenue,
                  :modifiedTime,
                  :itemStock,

    def self.create(item)
      RestClient.post("#{base_url}/items", item.remote_attributes, headers) do |response, request, result|
        begin
          case response.code
          when 200
            inventory_item = new(JSON.parse(response))
            item.remote_id = inventory_item.id
            item.save
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError
        end
      end
    end

    def self.find(item)
      RestClient.get("#{base_url}/items/#{item.remote_id}?expand=itemStock", headers) do |response, request, result|
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
      RestClient.post("#{base_url}/items/#{item.remote_id}?expand=itemStock", item.remote_attributes, headers) do |response, request, result|
        begin
          case response.code
          when 200
            inventory_item = new(JSON.parse(response))
            item.remote_id ||= inventory_item.id
            item.save
            Clover::ItemStock.update(item)
            inventory_item
          when 404
            item.remote_id = nil
            item.save
            item.sync_inventory
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/items", headers) do |response, request, result|
        begin
          case response.code
          when 200
            items = JSON.parse(response)["elements"]
            items.map { |i| new(i) }
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError
        end
      end
    end

    def self.delete(item)
      RestClient.delete("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        begin
          if [200, 400].include?(response.code)
            Items::Updater.new(item).update(remote_id: nil)
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError
        end
      end
    end

  end
end
