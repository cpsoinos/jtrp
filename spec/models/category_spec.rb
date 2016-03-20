describe Category do

  it { should have_many(:items) }
  it { should belong_to(:company) }
  it { should validate_presence_of(:name) }
end
