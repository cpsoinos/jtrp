require 'active_job/traffic_control'

class DeleteDerivedResourcesJob < ActiveJob::Base
  queue_as :maintenance
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 1000, period: 1.hour

  def perform
    delete_derived_resources
  end

  private

  def derived_resource_ids
    Photo.all.map(&:derived_resource_ids).flatten.compact
  end

  def delete_derived_resources
    derived_resource_ids.in_batches(batch_size: 100) do |batch|
      Cloudinary::Api.delete_derived_resources(batch)
    end
  end

end
