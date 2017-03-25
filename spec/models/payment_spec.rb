describe Payment do


  context "validations" do

    before do
      allow(Clover::Payment).to receive(:find)
      allow(Payment::Processor).to receive(:new).and_return(processor)
      allow(processor).to receive(:process)
    end

    subject { create(:payment, remote_id: '3KVFXMRVTYF4C') }
    it { should validate_uniqueness_of(:remote_id).with_message("remote_id already taken").allow_nil }

    it { should monetize(:amount).allow_nil }
    it { should monetize(:tax_amount).allow_nil }

  end

  let(:processor) { double("processor") }

  it 'processes the payment after create' do
    allow(Payment::Processor).to receive(:new).and_return(processor)
    allow(processor).to receive(:process)

    build(:payment, remote_id: '3KVFXMRVTYF4C')

    expect(processor).to have_received(:process)
  end

end
