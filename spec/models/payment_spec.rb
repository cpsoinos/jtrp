describe Payment do

  subject { create(:payment, remote_id: 'abc123') }
  it { should validate_uniqueness_of(:remote_id).with_message("remote_id already taken").allow_nil }

  it { should monetize(:amount).allow_nil }
  it { should monetize(:tax_amount).allow_nil }

end
