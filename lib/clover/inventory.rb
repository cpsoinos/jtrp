require 'rest-client'

module Clover
  class Inventory < CloverBase

    def self.create(item)
      RestClient.post("#{base_url}/items", item.remote_attributes, headers) do |response, request, result|
        begin
          case response.code
          when 200
            inventory_item = DeepStruct.wrap(JSON.parse(response))
            item.remote_id = inventory_item.id
            item.save
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          # Rollbar.error(e, result.message,  item_id: item.id, response: response, result: result)
        end
      end
    end

    def self.find(item)
      RestClient.get("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          # Rollbar.error(e, result.message,  item_id: item.id, response: response, result: result)
        end
      end
    end

    def self.update(item)
      RestClient.post("#{base_url}/items/#{item.remote_id}", item.remote_attributes, headers) do |response, request, result|
        begin
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
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          # Rollbar.error(e, result.message,  item_id: item.id, response: response, result: result)
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/items", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response)["elements"])
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          # Rollbar.error(e, result.message,  response: response, result: result)
        end
      end
    end

    def self.delete(item)
      RestClient.delete("#{base_url}/items/#{item.remote_id}", headers) do |response, request, result|
        begin
          if [200, 400].include?(response.code)
            Item::Updater.new(item).update(remote_id: nil)
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          # Rollbar.error(e, result.message,  item_id: item.id, response: response, result: result)
        end
      end
    end

  end
end
