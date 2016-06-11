class Client < User
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
    end
  end

end
