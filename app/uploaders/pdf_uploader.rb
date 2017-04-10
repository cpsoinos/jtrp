class PdfUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def default_public_id
    ENV['CLOUDINARY_DEFAULT_IMAGE_ID']
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{cache_id}_#{original_filename}" if original_filename
  end

  def public_id
    model.short_name
  end

end
