class CreateOrUpdateSwiftypeDocumentJob < ActiveJob::Base
  queue_as :default

  attr_reader :item

  def perform(item)
    @item = item

    client.create_or_update_document(
      ENV['SWIFTYPE_ENGINE_SLUG'],
      Item.model_name.downcase,
      {
        external_id: item.id,
        fields: [
          { name: 'description', value: item.description, type: 'string' },
          { name: 'status', value: item.status, type: 'string'} ,
          { name: 'url', value: url, type: 'enum'} ,
          { name: 'created_at', value: item.created_at.iso8601, type: 'date' }
        ]
      }
    )
  end

  private

  def url
    Rails.application.routes.url_helpers.item_url(item)
  end

  def client
    Swiftype::Client.new
  end

end
