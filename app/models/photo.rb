class Photo < ApplicationRecord
  acts_as_paranoid
  acts_as_list scope: :item
  audited associated_with: :item

  belongs_to :item, touch: true, optional: true
  belongs_to :proposal, touch: true, optional: true
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
    if photo.file
      photo.file.public_id
    else
      Photo.default_photo.public_id
    end
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
