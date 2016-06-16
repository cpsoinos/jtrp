class ArchiveUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  def store_dir
    "archives"
  end

  def guid
    Time.now.utc.strftime("%Y-%m-%d-%H%M%S")
  end
end
