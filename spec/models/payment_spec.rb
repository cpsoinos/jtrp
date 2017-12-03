describe Payment do

  let(:processor) { double("processor") }

  it { should be_audited.associated_with(:order) }

  before do
    allow(Clover::Payment).to receive(:find)
    allow(Payments::Processor).to receive(:new).and_return(processor)
    allow(processor).to receive(:process)
  end

  context "validations" do

    subject { create(:payment, remote_id: '3KVFXMRVTYF4C') }
    it { should validate_uniqueness_of(:remote_id).with_message("remote_id already taken").allow_nil }

    it { should monetize(:amount).allow_nil }
    it { should monetize(:tax_amount).allow_nil }

  end

  it 'processes the payment after create' do
    payment = build(:payment, remote_id: '3KVFXMRVTYF4C')
    payment.save

    expect(Payments::Processor).to have_received(:new).with(payment)
    expect(processor).to have_received(:process)
  end

end
