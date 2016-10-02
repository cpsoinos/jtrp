class Statement < ActiveRecord::Base
  audited associated_with: :agreement

  belongs_to :agreement, touch: true
  has_one :statement_pdf
  has_one :account, through: :agreement

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
    agreement.items.sold.where(sold_at: starting_date..ending_date).order(:sold_at)
  end

  def total_sales
    items.map do |item|
      (item.sale_price_cents / 100)
    end.sum
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

  private

  def starting_date
    created_at.last_month.beginning_of_month
  end

  def ending_date
    created_at.last_month.end_of_month
  end

end
