class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :thumb do
    process resize_to_fit: [200,200]
  end

  version :tiny_thumb do
    process resize_to_fit: [50,50]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{cache_id}#{original_filename}.#{file.extension}" if original_filename
  end

  process resize_to_fit: [800, 800]

  protected

end
