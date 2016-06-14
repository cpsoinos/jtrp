describe ItemImporter do

  let(:proposal) { create(:proposal) }
  let(:archive) { File.open(File.join(Rails.root, '/spec/fixtures/archive.zip')) }

  it "can be instantiated" do
    expect(ItemImporter.new(proposal)).to be_an_instance_of(ItemImporter)
  end

  it "imports items" do
    pending("rubyzip unzipping specs")
    expect {
      ItemImporter.new(proposal).import(archive)
    }.to change {
      Item.count
    }.by(2)
  end

end
