require 'rest-client'

module Clover
  class Payment < CloverBase

    def self.find(payment)
      RestClient.get("#{base_url}/payments/#{payment.remote_id}", headers) do |response, request, result|
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
          Airbrake.notify(e, {message: result.message,  payment_id: payment.id, response: response, result: result})
        end
      end
    end

    def self.all(params={})
      params = headers.merge(params: params)
      RestClient.get("#{base_url}/payments", params) do |response, request, result|
        begin
          case response.code
          when 200
            DeepStruct.wrap(JSON.parse(response)["elements"])
          else
            raise CloverError.new(result.message)
          end
        rescue CloverError => e
          Airbrake.notify(e, {message: result.message,  response: response, result: result})
        end
      end
    end

  end
end
