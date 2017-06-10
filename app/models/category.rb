class Category < ApplicationRecord
  include PublicActivity::Common

  acts_as_paranoid
  audited

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  has_many :items
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category", touch: true
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true

  scope :primary, -> { where(parent: nil) }
  scope :secondary, -> { where.not(parent: nil) }
  scope :categorized, -> { where.not(slug: "uncategorized") }

  def subcategory?
    parent.present?
  end

  def parent?
    Rails.cache.fetch(cache_key) do
      subcategories.present?
    end
  end

  def lowest_price
    Rails.cache.fetch([cache_key, "lowest_price"]) do
      items.where("listing_price_cents > ?", 0).order(:listing_price_cents).limit(1).first.try(:listing_price)
    end
  end

  def featured_photo
    Rails.cache.fetch([cache_key, "item_photo"]) do
      items.active.sample.try(:featured_photo) || self # fallback to own photo
    end
  end

end
