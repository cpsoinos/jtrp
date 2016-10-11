describe Company do

  it { should validate_presence_of(:name) }
  it { should belong_to(:primary_contact) }

  let(:company) { create(:company) }

  it "jtrp" do
    expect(Company.jtrp).to eq(Company.first)
    expect(Company.jtrp.name).to eq("Just the Right Piece")
  end

end
