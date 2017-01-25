SitemapGenerator::Sitemap.default_host = 'https://www.jtrpfurniture.com'

SitemapGenerator::Sitemap.create do
  Category.find_each do |category|
    add category_path(category), changefreq: 'daily', lastmod: category.updated_at

    category.items.each do |item|
      add category_item_path(category, item), changefreq: 'daily', lastmod: item.updated_at
    end

    Item.active.find_each do |item|
      add item_path(item), changefreq: 'daily', lastmod: item.updated_at
    end
    add about_path, changefreq: 'weekly'
    add contact_path, changefreq: 'weekly'
  end
end

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  fog_directory: ENV['FOG_DIRECTORY']
)

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.ping_search_engines('https://www.jtrpfurniture.com/sitemap')
