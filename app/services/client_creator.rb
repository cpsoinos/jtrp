class ClientCreator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create(attrs, proposal=nil)
    binding.pry
    @client = Client.new(attrs)
    @client.skip_password_validation = true

    if @client.save
      verify_account
    end
    @client
  end

  private

  def verify_account
    binding.pry
    if @client.account.nil?
      @client.create_account(primary_contact: @client)
    end
  end

  def create_proposal
    @client.account.proposals.create!(created_by: user)
  end

end
