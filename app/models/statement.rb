class Statement < ActiveRecord::Base
  audited associated_with: :agreement
  has_secure_token

  include Filterable

  belongs_to :account, touch: true
  belongs_to :agreement, touch: true
  has_one :statement_pdf

  scope :status, -> (status) { where(status: status) }
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
    account.items.sold.where(client_intention: "consign", sold_at: starting_date..ending_date).order(:sold_at)
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
    Rails.application.routes.url_helpers.account_statement_url(account, self, token: token, host: ENV['HOST'])
  end

  def starting_date
    created_at.last_month.beginning_of_month
  end

  def ending_date
    created_at.last_month.end_of_month
  end

  def task
    if unpaid?
      { name: "pay statement", description: "needs to be paid and sent to the client" }
    elsif paid?
      if check_number.nil?
        { name: "record check number", description: "needs a check number recorded", task_field: :check_number }
      end
    end
  end

end
