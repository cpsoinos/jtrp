class Photo < ActiveRecord::Base
  belongs_to :item
  mount_uploader :photo, PhotoUploader

  validates :item, presence: true
  validates :photo_type, presence: true

  scope :initial, -> { where(photo_type: 'initial') }
  scope :listing, -> { where(photo_type: 'listing') }

end
