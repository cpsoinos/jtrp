class Company < ActiveRecord::Base

  has_many :categories
  has_many :items, through: :categories

  validates :name, presence: true, uniqueness: true

end
