class WebhookEntry < ApplicationRecord
  belongs_to :webhook
  belongs_to :webhookable, polymorphic: true, touch: true, optional: true

  scope :processed, -> { where(processed: true) }
  scope :unprocessed, -> { where(processed: false) }

  validates :processed, inclusion: { in: [ true, false ] }

  after_create :process

  def process
    if webhookable_type == "Item"
      webhookable.update_attributes(stock: webhookable.remote_object.try(:itemStock).try(:quantity))
      mark_processed
    end
  end

  def mark_processed
    self.processed = true
    self.save
  end

end
