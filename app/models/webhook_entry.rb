class WebhookEntry < ActiveRecord::Base
  belongs_to :webhook
  belongs_to :webhookable, polymorphic: true

  scope :processed, -> { where(processed: true) }
  scope :unprocessed, -> { where(processed: false) }

  validates :processed, inclusion: { in: [ true, false ] }

  def process
    WebhookProcessorJob.perform_later(self)
  end

  def mark_processed
    self.processed = true
    self.save
  end

end
