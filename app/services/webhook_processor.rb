class WebhookProcessor

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def process
    @record = create_record
    process_objects
  end

  private

  def create_record
    Webhook.create(integration: "clover", data: data)
  end

  def process_objects
    @record.objects.each do |object|
      local_object(object).process_webhook(@record)
    end
  end

  def local_object(object)
    identifier_type = object["objectId"].split(":").first
    identifier = object["objectId"].split(":").last
    case identifier_type
    when "I"
      Item.find_by(remote_id: identifier)
    when "O"
      Order.find_or_create_by(remote_id: identifier)
    end
  end

end
