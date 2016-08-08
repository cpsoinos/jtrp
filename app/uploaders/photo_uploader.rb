class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :thumb do
    resize_to_fit(200, 200)
  end

  version :small_thumb do
    resize_to_fit(100, 100)
  end

  version :tiny_thumb do
    resize_to_fit(50, 50)
  end

  version :enhanced do
    cloudinary_transformation effect: "viesus_correct", sign_url: true
  end

  def default_url
    ActionController::Base.helpers.asset_path("image_placeholder.jpg")
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{cache_id}_#{original_filename}" if original_filename
  end

end
