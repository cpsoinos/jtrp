describe PdfGenerator do

  let(:letter) { create(:letter) }
  let(:generator) { PdfGenerator.new(letter) }

  it "can be instantiated" do
    expect(generator).to be_an_instance_of(PdfGenerator)
  end

  it "creates a PDF", :vcr do
    allow(letter).to receive(:object_url).and_return("https://jtrp.ngrok.io/accounts/guy/letters/14?token=pvEFwvoJBV4V")
    generator.render_pdf
    letter.reload

    expect(letter.letter_pdf.url).not_to be(nil)
  end

  it "raises an error when pdf creation fails", :vcr do
    allow(letter).to receive(:object_url).and_return("https://jtrp.ngrok.io/accounts/anthony/letters/6?token=H1ZQKG7xnQmJ")
    allow(Airbrake).to receive(:notify)
    generator.render_pdf
    letter.reload

    expect(Airbrake).to have_received(:notify)
  end

end
