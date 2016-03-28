class Category < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  has_many :items
  belongs_to :company

  validates :name, presence: true, uniqueness: true

end
