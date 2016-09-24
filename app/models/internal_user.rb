class InternalUser < User
  has_one :company

  def account
    Account.find_by(primary_contact_id: id)
  end
end
