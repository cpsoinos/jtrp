class Photo < ActiveRecord::Base
  audited associated_with: :item

  belongs_to :item, touch: true
  belongs_to :proposal, touch: true
  mount_uploader :photo, PhotoUploader

  validates :photo_type, presence: true

  scope :initial, -> { where(photo_type: 'initial') }
  scope :listing, -> { where(photo_type: 'listing') }
  scope :featured, -> { where(photo_type: 'featured') }

  def self.default_url
    ActionController::Base.helpers.asset_path("image_placeholder.jpg")
  end

  def self.default_photo
    Photo.find_by(photo_type: 'default')
  end

end
