describe PdfGenerator do

  let(:letter) { create(:letter) }
  let(:generator) { PdfGenerator.new(letter) }

  it "can be instantiated" do
    expect(generator).to be_an_instance_of(PdfGenerator)
  end

  context :vcr do

    before do
      CarrierWave.configure do |config|
        config.enable_processing = true
      end
    end

    after do
      CarrierWave.configure do |config|
        config.enable_processing = false
      end
    end

    it "creates a PDF for a letter", :vcr do
      generator.render_pdf
      letter.reload

      expect(letter.pdf_url).not_to be(nil)
    end

    it "creates a PDF for an agreement", :vcr do
      agreement = create(:agreement)
      PdfGenerator.new(agreement).render_pdf

      expect(agreement.pdf_url).not_to be(nil)
    end

    it "creates a PDF for a statement", :vcr do
      statement = create(:statement)
      PdfGenerator.new(statement).render_pdf

      expect(statement.pdf_url).not_to be(nil)
    end

    it "raises an error when pdf creation fails", :vcr do
      allow(letter).to receive(:object_url).and_return("https://jtrp.ngrok.io/accounts/anthony/letters/6?token=H1ZQKG7xnQmJ")
      allow(Airbrake).to receive(:notify)
      generator.render_pdf
      letter.reload

      expect(Airbrake).to have_received(:notify)
    end

  end

end
