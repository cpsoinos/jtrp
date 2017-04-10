class Statement < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable_on :tags
  audited associated_with: :account
  has_secure_token

  include Filterable

  mount_uploader :pdf, PdfUploader

  belongs_to :account, touch: true
  has_one :statement_pdf
  has_many :checks

  scope :status, -> (status) { where(status: status) }
  scope :unpaid, -> { where(status: "unpaid") }
  scope :paid, -> { where(status: "paid") }

  state_machine :status, initial: :unpaid do
    state :unpaid
    state :paid

    after_transition unpaid: :paid, do: :create_and_send_check

    event :pay do
      transition unpaid: :paid
    end
  end

  def short_name
    "#{date.strftime('%m-%y')}_#{account.short_name}_consigned_sales"
  end

  def items
    account.items.sold.where(client_intention: "consign", sold_at: starting_date..ending_date).order(:sold_at)
  end

  def total_sales
    Money.new(items.sum(:sale_price_cents))
  end

  def total_consignment_fee
    items.map do |item|
      Money.new(item.sale_price * (item.consignment_rate / 100))
    end.sum
  end

  def total_parts_and_labor
    Money.new(items.sum(:parts_cost_cents) + items.sum(:labor_cost_cents))
  end

  def amount_due_to_client
    Money.new(items.sum(:sale_price_cents)) - total_consignment_fee - total_parts_and_labor
  end

  def object_url
    Rails.application.routes.url_helpers.account_statement_url(account, self, token: token, host: ENV['HOST'])
  end

  def starting_date
    date.last_month.beginning_of_month
  end

  def ending_date
    date.last_month.end_of_month
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

  def paid_manually?
    self.tag_list.include?("paid_manually")
  end

  def create_and_send_check
    return if paid_manually?
    CheckSenderJob.perform_later(self)
  end

end
