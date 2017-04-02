class Webhook < ActiveRecord::Base
  has_many :webhook_entries

  after_create :create_webhook_entries

  def remote_entries
    begin
      data["merchants"][ENV["CLOVER_MERCHANT_ID"]]
    rescue NoMethodError
      []
    end
  end

  def clover?
    integration == 'clover'
  end

  def lob?
    integration == 'lob'
  end

  private

  def create_webhook_entries
    remote_entries.each do |entry|
      Webhooks::Entries::Creator.new(self, entry).create
    end
  end

end
