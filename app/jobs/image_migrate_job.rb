class ImageMigrateJob < ActiveJob::Base
  queue_as :default

  attr_reader :photo

  def perform(photo)
    @photo = photo
    migrate_photo
  end

  private

  def migrate_photo
    photo.remote_photo_url = remote_photo_url
    photo.save
  end

  def remote_photo_url
    "https://s3.amazonaws.com/#{ENV['FOG_DIRECTORY']}/#{photo.photo.store_dir}/#{photo.photo.send(:original_filename)}"
  end

end
