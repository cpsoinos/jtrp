CarrierWave.configure do |config|

  if Rails.env.test?
    config.enable_processing = false
  else
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']  # required
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']           # required
    config.cache_dir = "#{Rails.root}/tmp/"
    config.permissions = 0666
    config.storage = :fog
    config.max_file_size = 1024.megabytes
  end

end
