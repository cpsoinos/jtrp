Premailer::Rails.config.merge!(
  # preserve_styles: true,
  base_url: ENV['HOST'],
  adapter: :nokogiri
)
