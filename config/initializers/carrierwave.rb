CarrierWave.configure do |config|

  if Rails.env.test?
    # Fog.mock!
    #
    # def fog_directory
    #   'test_bucket'
    # end
    #
    # connection = ::Fog::Storage.new(
    #   :aws_access_key_id      => 'fake_key_id',
    #   :aws_secret_access_key  => 'fake_access_key',
    #   :provider               => 'AWS'
    # )
    #
    # connection.directories.create(:key => fog_directory)
    # # config.fog_directory  = ENV['FOG_DIRECTORY']           # required
    # #
    # # config.storage = :fog
    # #
    config.enable_processing = false
    #
    #
    # # config.fog_provider = 'fog/aws'                        # required
    # config.fog_credentials = {
    #   provider:              'AWS',                        # required
    #   aws_access_key_id:     'fake_key_id',
    #   aws_secret_access_key: 'fake_access_key'
    #   # region:                'us-west-2',                  # optional, defaults to 'us-east-1'
    #   # host:                  's3.example.com',             # optional, defaults to nil
    #   # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    # }
    # config.fog_directory  = 'test_bucket'           # required
    # config.storage = :fog
    # # config.fog_public     = false                                        # optional, defaults to true
    # # config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
    # config.max_file_size = 1024.megabytes

  else
    # config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']  # required
      # region:                'us-west-2',                  # optional, defaults to 'us-east-1'
      # host:                  's3.example.com',             # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']           # required
    config.cache_dir = "#{Rails.root}/tmp/"
    config.permissions = 0666
    config.storage = :fog
    # config.fog_public     = false                                        # optional, defaults to true
    # config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
    config.max_file_size = 1024.megabytes
  end

end
