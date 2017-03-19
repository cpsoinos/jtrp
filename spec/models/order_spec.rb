describe Order do

  it { should have_many(:items) }
  it { should have_many(:discounts) }
  it { should have_many(:webhook_entries) }
  it { should have_many(:payments) }

  subject { create(:order, remote_id: 'abc123') }
  it { should validate_uniqueness_of(:remote_id).with_message("remote_id already taken").allow_nil }

  it { should monetize(:amount).allow_nil }

  context "scopes" do

    before do
      allow_any_instance_of(Payment).to receive(:process)
    end

    it "paid" do
      paid_orders = create_list(:order, 3)
      paid_orders.each { |o| create(:payment, order: o) }
      unpaid_order = create(:order)

      expect(Order.paid).to match_array(paid_orders)
    end

  end

end
