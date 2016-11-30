module Cloudinary
  class DeleteDerivedResourcesJob < ActiveJob::Base
    queue_as :maintenance

    def perform
      delete_derived_resources
    end

    private

    def delete_derived_resources
      res = Cloudinary::Api.delete_all_resources(:keep_original => true)
      while res.has_key?("next_cursor") do
        res = Cloudinary::Api.delete_all_resources(:keep_original => true, :next_cursor => res["next_cursor"])
      end
    end

  end
end
