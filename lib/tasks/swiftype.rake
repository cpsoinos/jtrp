task :index_items => :environment do
  if ENV['SWIFTYPE_API_KEY'].blank?
    abort("SWIFTYPE_API_KEY not set")
  end

  if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
    abort("SWIFTYPE_ENGINE_SLUG not set")
  end

  client = Swiftype::Client.new

  Item.find_in_batches(:batch_size => 100) do |items|
    documents = items.map do |item|
      url = Rails.application.routes.url_helpers.item_url(item)
      {
        external_id: item.id,
        fields: [
          { name: 'description', value: item.description, type: 'string' },
          { name: 'status', value: item.status, type: 'string'} ,
          { name: 'url', value: url, type: 'enum'} ,
          { name: 'created_at', value: item.created_at.iso8601, type: 'date' }
        ]
      }
    end

    results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], 'items', documents)

    results.each_with_index do |result, index|
      puts "Could not create #{items[index].title} (##{items[index].id})" if result == false
    end
  end
end
