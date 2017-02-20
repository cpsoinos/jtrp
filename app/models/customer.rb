class Customer < ActiveRecord::Base
  acts_as_paranoid

  has_many :webhook_entries, as: :webhookable

  validates :remote_id, uniqueness: true
  
end
