describe Account do

  it { should have_many(:clients) }
  it { should belong_to(:primary_contact) }
  it { should have_many(:proposals) }
  it { should have_many(:items).through(:proposals) }
  it { should belong_to(:created_by) }
  it { should belong_to(:updated_by) }

  let!(:account) { create(:account) }
  it { should validate_uniqueness_of(:account_number) }

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

end
