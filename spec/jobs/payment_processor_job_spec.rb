describe PaymentProcessorJob do

  let(:payment) { create(:payment) }
  let(:processor) { double("processor") }

  before do
    allow_any_instance_of(Payment).to receive(:process)
    allow(Payments::Processor).to receive(:new).and_return(processor)
    allow(processor).to receive(:process)
  end

  it 'processes a payment' do
    PaymentProcessorJob.perform_later(payment_id: payment.id)

    expect(processor).to have_received(:process)
  end

end
