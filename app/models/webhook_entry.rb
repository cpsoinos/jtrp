class WebhookEntry < ApplicationRecord
  belongs_to :webhook
  belongs_to :webhookable, polymorphic: true, touch: true

  scope :processed, -> { where(processed: true) }
  scope :unprocessed, -> { where(processed: false) }

  validates :processed, inclusion: { in: [ true, false ] }

  def mark_processed
    self.processed = true
    self.save
  end

end
