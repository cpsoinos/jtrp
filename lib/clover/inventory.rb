require 'rest-client'

module Clover
  class Inventory < Clover::CloverBase

    def self.create(item)
      RestClient.post("#{base_url}/items", {
        name: item.description,
        cost: (item.purchase_price_cents || 0),
        price: item.listing_price_cents,
        sku: item.id,
        alternateName: item.token
      }.to_json, headers) do |response, request, result|
        case response.code
        when 200
          inventory_item = DeepStruct.wrap(JSON.parse(response))
          item.remote_id = inventory_item.id
          item.save
        else
          raise "unable to create inventory item - #{result.to_s}"
        end
      end
    end

    def self.find(item)
      RestClient.get("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response))
        when 404
          nil
        else
          raise 'unable to find item - ' + result.to_s
        end
      end
    end

    def self.update(item)
      RestClient.post("#{base_url}/items/#{item.remote_id}", {
        name: item.description,
        cost: (item.purchase_price_cents || 0),
        price: item.listing_price_cents,
        sku: item.id,
        alternateName: item.token
      }.to_json, headers) do |response, request, result|
        case response.code
        when 200
          inventory_item = DeepStruct.wrap(JSON.parse(response))
          item.remote_id ||= inventory_item.id
          item.save
        else
          raise 'unable to find item - ' + result.to_s
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/items", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response)["elements"])
        else
          raise 'unable to get all inventory items - ' + result.to_s
        end
      end
    end

    def self.delete(item)
      RestClient.delete("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        case response.code
        when 200
          ItemUpdater.new(item).update(remote_id: nil)
        else
          raise 'unable to delete item - ' + result.to_s
        end
      end
    end

  end
end
