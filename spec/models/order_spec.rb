describe Order do

  it { should have_many(:items) }
  it { should have_many(:discounts) }
  it { should have_many(:webhook_entries) }
  it { should have_many(:payments) }

  subject { create(:order, remote_id: 'abc123') }
  it { should validate_uniqueness_of(:remote_id).allow_nil }

  it { should monetize(:amount).allow_nil }

end
