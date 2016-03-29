class Category < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  has_many :items

  validates :name, presence: true, uniqueness: true

end
