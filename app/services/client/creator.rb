class Client::Creator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create(attrs, proposal=nil)
    @client = Client.new(attrs)
    @client.skip_password_validation = true
    @client.save
    @client
  end

  private

  def create_proposal
    @client.account.proposals.create!(created_by: user)
  end

end
