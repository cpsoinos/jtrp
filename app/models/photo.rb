class Photo < ActiveRecord::Base
  belongs_to :item, touch: true
  belongs_to :proposal
  mount_uploader :photo, PhotoUploader

  validates :photo_type, presence: true
  validates :item_id, uniqueness: { scope: :photo_type, message: "one featured photo per item" } if featured?
  # validates :primary, uniqueness: { scope: :item_id, message: "one primary photo per item" }, allow_blank: true, allow_nil: true

  scope :initial, -> { where(photo_type: 'initial') }
  scope :listing, -> { where(photo_type: 'listing') }
  scope :featured, -> { where(photo_type: 'featured') }

  def self.default_url
    ActionController::Base.helpers.asset_path("image_placeholder.jpg")
  end

  def featured?
    photo_type == 'featured'
  end

  private

  def validate_featured_photo
    if item.present?
      item.featured_photos.length <= 0
    end
  end

end
