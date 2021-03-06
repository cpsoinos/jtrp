describe LetterSenderJob do

  let(:letter) { create(:letter) }
  let(:sender) { double("sender") }

  before do
    allow(Letter::Sender).to receive(:new).with(letter).and_return(sender)
    allow(sender).to receive(:send_letter)
  end

  it "perform" do
    LetterSenderJob.perform_later(letter_id: letter.id)

    expect(Letter::Sender).to have_received(:new).with(letter)
    expect(sender).to have_received(:send_letter)
  end

end
