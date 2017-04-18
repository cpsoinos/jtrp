class Payment < ActiveRecord::Base
  include PublicActivity::Common
  
  acts_as_paranoid
  audited associated_with: :order

  belongs_to :order
  has_many :webhook_entries, as: :webhookable

  validates :remote_id, uniqueness: { message: "remote_id already taken" }, allow_nil: true

  after_commit :process, on: :create

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }
  monetize :tax_amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }

  def remote_object
    Clover::Payment.find(self)
  end

  def process
    PaymentProcessorJob.perform_later(self)
  end

end
