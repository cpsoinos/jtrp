class Check < ActiveRecord::Base
  acts_as_paranoid
  audited associated_with: :statement

  belongs_to :statement
  has_one :account, through: :statement

  mount_uploader :check_image_front, ScannedAgreementUploader
  mount_uploader :check_image_back, ScannedAgreementUploader

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  def memo
    "#{statement.date.last_month.strftime('%B')}, #{statement.last_month.date.strftime('%Y')} - Consigned Sales"
  end

  def name
    "#{account.short_name} - #{statement.date.last_month.strftime('%-m/%-d/%y')}"
  end

end
