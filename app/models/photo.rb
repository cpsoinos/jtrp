class Photo < ActiveRecord::Base
  acts_as_paranoid
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

  def public_id
    photo.file.public_id
  end

  def derived_resource_ids
    return if remote_object.nil?
    DeepStruct.wrap(remote_object).derived.map(&:id)
  end

  private

  def remote_object
    Cloudinary::Api.resource(public_id)
  rescue Cloudinary::Api::NotFound
    nil
  end

end
