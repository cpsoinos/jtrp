require 'active_job/traffic_control'

module Cloudinary
  class ImageConvertJob < ActiveJob::Base
    queue_as :maintenance
    include ActiveJob::TrafficControl::Throttle

    throttle threshold: 2000, period: 1.hour unless Rails.env.test?

    attr_reader :photo

    def perform(photo)
      @photo = photo
      resave_carrierwave(photo)
    end

    private

    def reupload_and_convert(photo)
      Cloudinary::Uploader.upload("http://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/#{identifier(photo)}", public_id: public_id(photo), upload_preset: 'limit_width_jpg')
    end

    def public_id(photo)
      photo.photo.file.public_id
    end

    def identifier(photo)
      photo.photo.file.identifier
    end

    def resave_carrierwave(photo)
      photo.remote_photo_url = reupload_and_convert(photo)["secure_url"]
      photo.save
    end

  end
end
