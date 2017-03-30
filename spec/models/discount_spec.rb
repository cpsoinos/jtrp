describe Discount do

  it { should be_audited }
  it { should belong_to(:discountable) }
  it { should validate_presence_of(:discountable) }

  subject { create(:discount, remote_id: 'abc123') }
  it { should validate_uniqueness_of(:remote_id).with_message("remote_id already taken").allow_nil }

  it { should monetize(:amount).allow_nil }

end
