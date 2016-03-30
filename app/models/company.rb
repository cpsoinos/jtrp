class Company < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  validates :name, presence: true

end
