class Category < ActiveRecord::Base
  include PublicActivity::Common
  
  acts_as_paranoid
  audited

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :history]

  has_many :items
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true

  scope :primary, -> { where(parent: nil) }
  scope :secondary, -> { where.not(parent: nil) }
  scope :categorized, -> { where.not(slug: "uncategorized") }

  def subcategory?
    parent.present?
  end

  def lowest_price
    items.where("listing_price_cents > ?", 0).order(:listing_price_cents).limit(1).first.try(:listing_price)
  end

end
