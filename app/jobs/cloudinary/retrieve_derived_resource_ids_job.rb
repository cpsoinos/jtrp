require 'active_job/traffic_control'

class RetrieveDerivedResourceIdsJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 1000, period: 1.hour

  attr_reader :derived_resource_ids

  def perform(derived_resource_ids)
    @derived_resource_ids = derived_resource_ids
    delete_derived_resources(derived_resource_ids)
  end

  private

  def delete_derived_resources(derived_resource_ids)
    Cloudinary::Api.delete_derived_resources(batch)
  end

end
