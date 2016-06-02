class ClientCreator

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create(attrs)
    @client = Client.new(attrs)
    if @client.save
      verify_account
    end
    @client
  end

  private

  def verify_account
    if @client.account.nil?
      @client.create_account
    end
  end

end
