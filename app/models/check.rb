class Check < ActiveRecord::Base
  include PublicActivity::Common

  acts_as_paranoid
  audited associated_with: :statement

  belongs_to :statement
  has_one :account, through: :statement
  has_many :webhook_entries, as: :webhookable

  mount_uploader :check_image_front, ScannedAgreementUploader
  mount_uploader :check_image_back, ScannedAgreementUploader

  monetize :amount_cents, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100000
  }

  after_touch :retrieve_images

  def memo
    "#{statement.date.last_month.strftime('%B')}, #{statement.date.last_month.strftime('%Y')} - Consigned Sales"
  end

  def name
    "#{account.short_name} - #{statement.date.last_month.strftime('%-m/%-d/%y')}"
  end

  def retrieve_images
    CheckImageRetrieverJob.perform_later(check_id: id)
  end

end
