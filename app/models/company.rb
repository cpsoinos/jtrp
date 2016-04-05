class Company < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  validates :name, presence: true

  def full_address
    "#{address_1}#{address_2.present? ? (', ' + address_2) : ''}, #{city}, #{state} #{zip}" 
  end

end
