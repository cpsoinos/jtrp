class Client < User
  belongs_to :account
  has_many :proposals, through: :account
  has_many :items, through: :proposals
end
