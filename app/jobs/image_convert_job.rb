class ImageConvertJob < ActiveJob::Base
  queue_as :default

  attr_reader :photo

  def perform(photo)
    @photo = photo
    resave_carrierwave(photo)
  end

  private

  def reupload_and_convert(photo)
    Cloudinary::Uploader.upload("http://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/#{identifier(photo)}", public_id: public_id(photo), format: "jpg")
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
