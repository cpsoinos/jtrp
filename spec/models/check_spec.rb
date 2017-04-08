describe Check do

  it { should be_audited.associated_with(:statement) }
  it { should belong_to(:statement) }
  it { should have_one(:account).through(:statement) }
  it { should have_many(:webhook_entries) }

  let(:check) { create(:check) }
  let(:statement) { check.statement }
  let(:account) { build_stubbed(:account, :with_client) }

  it "retrieves check images after_touch" do
    allow(CheckImageRetrieverJob).to receive(:perform_later)
    check.touch

    expect(CheckImageRetrieverJob).to have_received(:perform_later)
  end

  it "#memo" do
    expect(check.memo).to eq("#{statement.date.last_month.strftime('%B')}, #{statement.date.last_month.strftime('%Y')} - Consigned Sales")
  end

  it "#name" do
    allow(statement).to receive(:account).and_return(account)

    expect(check.name).to eq("#{account.short_name} - #{statement.date.last_month.strftime('%-m/%-d/%y')}")
  end

end
