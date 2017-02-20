class Payment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :order
  has_many :webhook_entries, as: :webhookable

  validates :remote_id, uniqueness: true
  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }
  monetize :tax_amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1000000
  }

end
