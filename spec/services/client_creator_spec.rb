describe Client::Creator do

  let(:user) { create(:internal_user) }
  let(:attrs) { attributes_for(:client) }

  it "can be instantiated" do
    expect(Client::Creator.new(user)).to be_an_instance_of(Client::Creator)
  end

  it "creates a client" do
    expect {
      Client::Creator.new(user).create(attrs)
    }.to change {
      Client.count
    }.by 1
  end

  it "creates an account for the client" do
    client = Client::Creator.new(user).create(attrs)

    expect(client.reload.account).not_to be(nil)
  end

  it "does not create a new account if passed an account id on create" do
    account = create(:account)
    attrs.merge!(account_id: account.id)

    expect {
      Client::Creator.new(user).create(attrs)
    }.not_to change {
      Account.count
    }
  end

end
