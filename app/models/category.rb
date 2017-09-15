class Category < ApplicationRecord
  include PublicActivity::Common

  acts_as_paranoid
  audited

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  has_many :items
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category", touch: true, optional: true, counter_cache: :subcategories_count
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true

  scope :primary, -> { where(parent: nil) }
  scope :secondary, -> { where.not(parent: nil) }
  scope :categorized, -> { where.not(slug: "uncategorized") }

  def subcategory?
    parent_id.present?
  end

  def parent?
    subcategories_count != 0
  end

  def lowest_price
    Rails.cache.fetch([cache_key, "lowest_price"]) do
      items.active.where("listing_price_cents > ?", 0).order(:listing_price_cents).first.try(:listing_price)
    end
  end

  def featured_photo
    Rails.cache.fetch([cache_key, "item_photo"]) do
      items.has_photos.active.sample.try(:featured_photo).try(:photo) || self.photo
    end
  end

end
