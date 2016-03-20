describe Item do

  it { should belong_to(:category) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:name) }

  let(:item) { create(:item) }

  it 'has a company' do
    expect(item.company).not_to be(nil)
  end

end
