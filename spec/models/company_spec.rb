describe Company do

  it { should have_many(:categories) }
  it { should have_many(:items).through(:categories) }
  it { should validate_presence_of(:name) }

end
