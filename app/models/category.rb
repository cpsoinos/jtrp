class Category < ActiveRecord::Base
  has_many :items
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"
  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true

  scope :primary, -> { where(parent: nil) }
  scope :secondary, -> { where.not(parent: nil) }

  def self.uncategorized
    Category.find_or_create_by(name: "Uncategorized")
  end

  def subcategory?
    parent.present?
  end

end
