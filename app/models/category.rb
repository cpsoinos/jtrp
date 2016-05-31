class Category < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  has_many :items
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"

  validates :name, presence: true, uniqueness: true

  scope :primary, -> { where(parent: nil) }
  scope :secondary, -> { where.not(parent: nil) }

  def subcategory?
    parent.present?
  end
end
