require 'rest-client'

module Clover
  class Inventory < Clover::CloverBase

    def self.create(item)
      RestClient.post("#{base_url}/items", {
        name: item.description,
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
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, item_id: item.id, error: JSON.parse(response))
      raise e
    end

    def self.find(item)
      RestClient.get("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response))
        when 404
          nil
        else
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, item_id: item.id, error: JSON.parse(response))
      raise e
    end

    def self.update(item)
      RestClient.post("#{base_url}/items/#{item.remote_id}", {
        name: item.description,
        price: item.listing_price_cents,
        sku: item.id,
        alternateName: item.token
      }.to_json, headers) do |response, request, result|
        case response.code
        when 200
          inventory_item = DeepStruct.wrap(JSON.parse(response))
          item.remote_id ||= inventory_item.id
          item.save
        when 404
          item.remote_id = nil
          item.save
          item.sync_inventory
        else
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, item_id: item.id, error: JSON.parse(response))
      raise e
    end

    def self.all
      RestClient.get("#{base_url}/items", headers) do |response, request, result|
        case response.code
        when 200
          DeepStruct.wrap(JSON.parse(response)["elements"])
        else
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, error: JSON.parse(response))
      raise e
    end

    def self.delete(item)
      RestClient.delete("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        if [200, 400].include?(response.code)
          ItemUpdater.new(item).update(remote_id: nil)
        else
          raise CloverError
        end
      end
    rescue CloverError => e
      Rollbar.error(e, item_id: item.id, error: JSON.parse(response))
      raise e
    end

  end
end
