class Client < User
  include PgSearch
  include PublicActivity::Common

  multisearchable against: [:first_name, :last_name, :email, :full_name, :address_1, :city, :state, :zip, :status]

  belongs_to :account, optional: true
  has_many :proposals, through: :account
  has_many :items, through: :proposals

  after_create :verify_account

  private

  def verify_account
    if account.nil?
      create_account(primary_contact: self)
      save
    end
  end

end
