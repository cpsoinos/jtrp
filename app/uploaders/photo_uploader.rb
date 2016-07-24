class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :standard do
    eager
    process resize_to_fill: [800,800]
  end

  version :thumb do
    eager
    resize_to_fit(200, 200)
  end

  version :small_thumb do
    resize_to_fit(100, 100)
  end

  version :tiny_thumb do
    resize_to_fit(50, 50)
  end

  process convert: 'png'

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{cache_id}_#{original_filename}" if original_filename
  end

end
