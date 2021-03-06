class Webhook < ApplicationRecord
  has_many :webhook_entries

  after_create :create_webhook_entries

  def remote_entries
    if clover?
      begin
        data["merchants"][ENV["CLOVER_MERCHANT_ID"]]
      rescue NoMethodError
        []
      end
    elsif lob?
      [data]
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
    return unless remote_entries.present?
    remote_entries.each do |entry|
      Webhooks::Entries::Creator.new(self, entry).create
    end
  end

end
