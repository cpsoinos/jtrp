class Statement < ActiveRecord::Base

  belongs_to :agreement
  monetize :balance_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  scope :unpaid, -> { where(status: "unpaid") }
  scope :paid, -> { where(status: "paid") }

  state_machine :status, initial: :unpaid do
    state :unpaid
    state :paid

    event :pay do
      transition unpaid: :paid
    end

  end

  delegate :account, to: :agreement

  def items
    agreement.items.consigned.sold.where(sold_at: 1.month.ago..Date.today)
  end

end
