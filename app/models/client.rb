class Client < User
  include PgSearch

  multisearchable against: [:first_name, :last_name, :email, :full_name, :address_1, :city, :state, :zip, :status]

  belongs_to :account
  has_many :proposals, through: :account
  has_many :items, through: :proposals

  after_create :verify_account

  def address_string
    GeolocationService.new(self).location_string
  end

  private

  def verify_account
    if account.nil?
      create_account(primary_contact: self)
      save
    end
  end

end
