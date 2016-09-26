class Statement < ActiveRecord::Base
  belongs_to :agreement, touch: true
  has_one :statement_pdf
  has_one :account, through: :agreement

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

  def items
    agreement.items.sold.where(sold_at: 1.month.ago..Date.today).order(:sold_at)
  end

  def total_consignment_fee
    items.map do |item|
      (item.sale_price_cents / 100 * item.consignment_rate) / 100
    end.sum
  end

  def amount_due_to_client
    items.sum(:sale_price_cents) / 100 - total_consignment_fee
  end

  def object_url
    Rails.application.routes.url_helpers.account_statement_url(account, self, host: ENV['HOST'])
  end

end
