describe ClientCreator do

  let(:user) { create(:internal_user) }
  let(:attrs) { attributes_for(:client) }

  it "can be instantiated" do
    expect(ClientCreator.new(user)).to be_an_instance_of(ClientCreator)
  end

  it "creates a client" do
    expect {
      ClientCreator.new(user).create(attrs)
    }.to change {
      Client.count
    }.by 1
  end

  it "creates an account for the client" do
    client = ClientCreator.new(user).create(attrs)

    expect(client.account).not_to be(nil)
  end

  it "does not create a new account if passed an account id on create" do
    account = create(:account)
    attrs.merge!(account_id: account.id)

    expect {
      ClientCreator.new(user).create(attrs)
    }.not_to change {
      Account.count
    }
  end

end
