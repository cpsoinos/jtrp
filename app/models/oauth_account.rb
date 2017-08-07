class OauthAccount < ApplicationRecord
  audited associated_with: :user

  belongs_to :user
  mount_uploader :image, PhotoUploader

  validates :user, presence: true

  scope :clover, -> { where(provider: 'clover') }
  scope :facebook, -> { where(provider: 'facebook') }
  scope :twitter, -> { where(provider: 'twitter') }
  scope :instagram, -> { where(provider: 'instagram') }
  scope :pinterest, -> { where(provider: 'pinterest') }

  def clover?
    provider == 'clover'
  end

  def facebook?
    provider == 'facebook'
  end

  def twitter?
    provider == 'twitter'
  end

  def instagram?
    provider == 'instagram'
  end

  def pinterest?
    provider == 'pinterest'
  end

end
