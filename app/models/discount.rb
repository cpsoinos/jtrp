class Discount < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :discountable, polymorphic: true

  monetize :amount_cents, allow_nil: true, numericality: {
    less_than_or_equal_to: 0
  }

  validates :discountable, presence: true
  validates :remote_id, uniqueness: { message: "remote_id already taken" }, allow_nil: true

end
