describe ItemImporter do

  let(:proposal) { create(:proposal) }
  let(:archive) { create(:archive) }
  let(:importer) { ItemImporter.new(proposal) }

  before do
    allow(importer).to receive(:zipfile).and_return(archive.archive)
    allow(archive.archive).to receive(:path).and_return(File.join(Rails.root, '/spec/fixtures/archive.zip'))
  end

  pending "Cloudinary direct uploads" do
    it "can be instantiated" do
      expect(importer).to be_an_instance_of(ItemImporter)
    end

    it "imports items" do
      expect {
        importer.import(archive)
      }.to change {
        Item.count
      }.by(2)
    end
  end

end
