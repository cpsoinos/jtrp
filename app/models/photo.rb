class Photo < ActiveRecord::Base
  belongs_to :item
  mount_uploader :photo, PhotoUploader

  validates :photo_type, presence: true

  scope :initial, -> { where(photo_type: 'initial') }
  scope :listing, -> { where(photo_type: 'listing') }
  scope :featured, -> { where(photo_type: 'featured') }

  def self.default_url
    ActionController::Base.helpers.asset_path("image_placeholder.jpg")
  end

end
