describe Account do

  it { should be_audited }
  it { should have_many(:clients) }
  it { should belong_to(:primary_contact) }
  it { should have_many(:jobs) }
  it { should have_many(:proposals).through(:jobs) }
  it { should have_many(:agreements).through(:proposals) }
  it { should have_many(:items).through(:proposals) }
  it { should belong_to(:created_by) }
  it { should belong_to(:updated_by) }

  let!(:account) { create(:account) }
  it { should validate_presence_of(:status) }

  describe Account, "state machine" do

    it "starts as 'potential'" do
      expect(Account.new).to be_potential
    end

    it "transitions 'potential' to 'active'" do
      account = create(:account)
      create(:job, :active, account: account)
      account.mark_active

      expect(account).to be_active
    end

    it "transitions 'active' to 'completed'" do
      account = create(:account, :active)
      create(:job, :completed, account: account)
      account.mark_inactive

      expect(account).to be_inactive
    end

    it "transitions 'potential' to 'inactive'" do
      item = create(:item)
      account = item.account
      account.mark_inactive!

      expect(account.reload).to be_inactive
      expect(item.reload).to be_inactive
    end

    it "transitions 'inactive' to 'active'" do
      account = create(:account, :inactive)
      account.reactivate!

      expect(account).to be_active
    end

  end

  it "primary_contact" do
    account = create(:account, :with_client)

    expect(account.primary_contact).to eq(account.clients.first)
  end

  context "client" do
    it "full_name" do
      account = create(:account, :with_client)

      expect(account.full_name).to eq(account.primary_contact.full_name)
    end

    it "inverse_full_name" do
      account = create(:account, :with_client)

      expect(account.inverse_full_name).to eq(account.primary_contact.inverse_full_name)
    end

    it "short_name" do
      account = create(:account, :with_client)

      expect(account.short_name).to eq(account.primary_contact.last_name)
    end
  end

  context "company" do
    it "full_name" do
      account = create(:account, :company)

      expect(account.full_name).to eq(account.company_name)
    end

    it "short_name" do
      account = build_stubbed(:account, :company)

      expect(account.short_name).to eq(account.company_name)
    end
  end

  it "yard_sale?" do
    yard_sale = Account.yard_sale

    expect(account.yard_sale?).to be(false)
    expect(yard_sale.yard_sale?).to be(true)
  end

  it "estate_sale?" do
    estate_sale = Account.estate_sale

    expect(account.estate_sale?).to be(false)
    expect(estate_sale.estate_sale?).to be(true)
  end

  it "OwnerAccount" do
    account = build_stubbed(:owner_account)
    expect(account.model_name).to eq("Account")
  end

  context "last_item_number" do
    it "returns 0 when no items present" do
      expect(account.last_item_number).to eq(0)
    end

    it "returns the largest account_item_number from its items" do
      proposal = create(:proposal, job: create(:job, account: account))
      item_a = create(:item, proposal: proposal, account_item_number: 1)
      item_b = create(:item, proposal: proposal, account_item_number: 2)
      item_c = create(:item, proposal: proposal, account_item_number: 3)

      expect(account.last_item_number).to eq(item_c.account_item_number)
    end

    it "returns 0 when items have no account item number" do
      proposal = create(:proposal, job: create(:job, account: account))
      create_list(:item, 3, proposal: proposal)

      expect(account.last_item_number).to eq(0)
    end

  end

end
