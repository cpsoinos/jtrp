Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  unless Rails.env.test?
    config.enhance_image_tag = true
    config.static_image_support = true
    config.secure = true
  end
end
