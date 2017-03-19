describe PaymentProcessorJob do

  let(:processor) { double("processor") }
  let(:payment) { build_stubbed(:payment) }
  
  before do
    allow(Payment).to receive(:find).and_return(payment)
    allow(Payment::Processor).to receive(:new).and_return(processor)
    allow(processor).to receive(:process)
  end
  
  it 'processes a payment' do
    PaymentProcessorJob.perform_later(123)

    expect(processor).to have_received(:process)
  end
  
end
