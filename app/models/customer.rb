class Customer < ApplicationRecord
  include PublicActivity::Common
  
  acts_as_paranoid

  has_many :webhook_entries, as: :webhookable

  validates :remote_id, uniqueness: { message: "remote_id already taken" }, allow_nil: true

end
