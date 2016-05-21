class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :thumb do
    process resize_to_fit: [200,200]
  end

  version :small_thumb do
    process resize_to_fit: [100,100]
  end

  version :tiny_thumb do
    process resize_to_fit: [50,50]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{cache_id}_#{original_filename}" if original_filename
  end

  def default_url(*args)
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "#{version_name}_No_Image_Available.png"
  end

  process resize_to_fit: [800, 800]

  protected

end
