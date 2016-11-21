class GiftCertificate < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :order

  belongs_to :order
  has_many :discounts

  monetize :initial_balance_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }
  monetize :current_balance_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  def self.default_remote_id
    "14QFV6H0K3N62"
  end
end
