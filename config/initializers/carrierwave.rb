CarrierWave.configure do |config|

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    # config.storage = :fog
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']  # required
      # region:                'us-west-2',                  # optional, defaults to 'us-east-1'
      # host:                  's3.example.com',             # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']           # required
    # config.fog_public     = false                                        # optional, defaults to true
    # config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end

end
