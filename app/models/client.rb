class Client < User
  belongs_to :account
  has_many :proposals, through: :account
  has_many :items, through: :proposals

  validates :primary_contact, uniqueness: { :scope => :account, message: "** DOUBLE PRIMARY CONTACT **" }  

  scope :potential, -> { where(status: "potential") }
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }

  state_machine :status, initial: :potential do
    state :potential
    state :active
    state :inactive

    event :mark_active do
      transition any => :active, if: lambda { |client| client.meets_requirements_active?}
    end

    event :mark_inactive do
      transition :active => :inactive, if: lambda { |client| client.meets_requirements_inactive? }
    end

  end

  def meets_requirements_active?
    proposals.active.present?
  end

  def meets_requirements_inactive?
    proposals.active.empty?
  end

end
