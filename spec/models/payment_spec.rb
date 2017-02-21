describe Payment do

  subject { create(:payment, remote_id: 'abc123') }
  it { should validate_uniqueness_of(:remote_id).allow_nil }

  it { should monetize(:amount).allow_nil }
  it { should monetize(:tax_amount).allow_nil }

end
