require 'rest-client'

module Clover
  class Customer < Clover::CloverBase

    # def self.create(opts)
    #   opts.symbolize_keys!
    #   RestClient.post("#{base_url}/customers", {
    #     firstName: opts[:firstName],
    #     lastName: opts[:lastName],
    #     customerSince: opts[:customerSince],
    #     marketingAllowed: opts[:marketingAllowed]
    #   }.to_json, headers) do |response, request, result|
    #     begin
    #       case response.code
    #       when 200
    #         # inventory_item = DeepStruct.wrap(JSON.parse(response))
    #         # item.remote_id = inventory_item.id
    #         # item.save
    #       else
    #         raise CloverError
    #       end
    #     rescue CloverError => e
    #       Rollbar.error(e, opts: opts, response: response, result: result)
    #     end
    #   end
    # end

    def self.find(customer)
      RestClient.get("#{base_url}/customers/#{customer.remote_id}", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response))
          when 404
            nil
          else
            raise CloverError
          end
        rescue CloverError => e
          Rollbar.error(e, customer_id: customer.id, response: response, result: result)
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/customers?limit=1000", headers) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response)["elements"])
          else
            raise CloverError
          end
        rescue CloverError => e
          Rollbar.error(e, response: response, result: result)
        end
      end
    end

  end
end
