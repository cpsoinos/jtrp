CarrierWave.configure do |config|

  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']  # required
    # region:                'us-west-2',                  # optional, defaults to 'us-east-1'
    # host:                  's3.example.com',             # optional, defaults to nil
    # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = ENV['FOG_DIRECTORY']           # required
  config.storage = :fog
  
  if Rails.env.test?
    Fog.mock!
    config.enable_processing = false

    def fog_directory
      ENV['FOG_DIRECTORY']
    end

    connection = ::Fog::Storage.new(
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
      :provider               => 'AWS'
    )

    connection.directories.create(:key => fog_directory)
  end
  config.max_file_size = 1024.megabytes

end
