class Item < ActiveRecord::Base

  belongs_to :category

  validates :category, presence: true
  validates :name, presence: true

  delegate :company, to: :category, allow_nil: false

end
