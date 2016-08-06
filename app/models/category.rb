class Category < ActiveRecord::Base
  has_many :items
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"
  belongs_to :photo

  validates :name, presence: true, uniqueness: true

  scope :primary, -> { where(parent: nil) }
  scope :secondary, -> { where.not(parent: nil) }

  def subcategory?
    parent.present?
  end

  def featured_photo_url
    if photo.present?
      photo.photo_url
    else
      "thumb_No_Image_Available.png"
    end
  end

end
