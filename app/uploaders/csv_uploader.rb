class CsvUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  def store_dir
    "item_spreadsheets"
  end

  def guid
    Time.now.utc.strftime("%Y-%m-%d-%H%M%S")
  end
end
