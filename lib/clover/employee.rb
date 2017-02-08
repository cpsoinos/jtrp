require 'rest-client'

module Clover
  class Employee < Clover::CloverBase

    def self.find(user)
      return unless user.internal?
      RestClient.get("#{base_url}/employees/#{user.remote_id}", headers) do |response, request, result|
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
          Rollbar.error(e, user_id: user.id, response: response, result: result)
        end
      end
    end

    def self.all
      RestClient.get("#{base_url}/employees", headers) do |response, request, result|
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
