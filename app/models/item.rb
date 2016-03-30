class Item < ActiveRecord::Base
  mount_uploaders :photos, PhotoUploader

  belongs_to :category

  validates :category, presence: true
  validates :name, presence: true

end
