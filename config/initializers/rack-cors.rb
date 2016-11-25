if defined? Rack::Cors
  Rails.configuration.middleware.insert_before 0, Rack::Cors do
    allow do
      origins %w[
        https://jtrpfurniture.com
        http://jtrpfurniture.com
        https://www.jtrpfurniture.com
        http://www.jtrpfurniture.com
        https://staging.jtrpfurniture.com
        http://staging.jtrpfurniture.com
        https://staging.jtrpfurniture.com
        http://staging.jtrpfurniture.com
      ]
      resource '/assets/*'
    end
  end
end
