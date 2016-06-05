describe Account do

  it { should have_many(:clients) }
  it { should belong_to(:primary_contact) }
  it { should have_many(:jobs) }
  it { should have_many(:proposals).through(:jobs) }
  it { should have_many(:items).through(:proposals) }
  it { should belong_to(:created_by) }
  it { should belong_to(:updated_by) }

  let!(:account) { create(:account) }
  it { should validate_uniqueness_of(:account_number) }
  it { should validate_presence_of(:status) }

  describe "callbacks" do
    it "sets the account number" do
      account = Account.new
      account.save

      expect(account.account_number).to eq(11)
    end

    it "increments the system info account number" do
      account = Account.new
      account.save

      expect(SystemInfo.first.last_account_number).to eq(12)
    end
  end

  it "client" do
    account = create(:account, :with_client)

    expect(account.primary_contact).to eq(account.clients.first)
  end

  it "full_name" do
    account = create(:account, :with_client)

    expect(account.full_name).to eq(account.primary_contact.full_name)
  end

end
