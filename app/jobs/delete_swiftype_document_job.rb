class DeleteSwiftypeDocumentJob < ActiveJob::Base
  queue_as :default

  attr_reader :item

  def perform(item)
    client.destroy_document(ENV['SWIFTYPE_ENGINE_SLUG'], Item.model_name.downcase, item.id)
  end

  private

  def client
    Swiftype::Client.new
  end

end
