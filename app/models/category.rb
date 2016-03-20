class Category < ActiveRecord::Base

  has_many :items
  belongs_to :company

  validates :name, presence: true, uniqueness: true

end
