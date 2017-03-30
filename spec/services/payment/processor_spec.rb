describe Payment::Processor do

  let(:payment) { create(:payment, order: nil, remote_id: "K4WF4WZET3962") }
  let(:processor) { Payment::Processor.new(payment) }

  before do
    allow_any_instance_of(Payment::Processor).to receive(:update_order).and_return(true)
  end

  it "can be instantiated", :vcr do
    expect(processor).to be_an_instance_of(Payment::Processor)
  end

  it "updates a payment", :vcr do
    processor.process

    expect(payment.amount_cents).to eq(2100)
    expect(payment.tax_amount_cents).to eq(0)
  end

  it "associates the payment with an existing order when present", :vcr do
    order = create(:order, remote_id: "FS7ADMT061Z1W")
    processor.process

    expect(payment.order).to eq(order)
  end

  it "creates a new order when an existing one is not present", :vcr do
    expect {
      processor.process
    }.to change {
      Order.count
    }.by(1)

    expect(payment.order).not_to be_nil
  end

end
