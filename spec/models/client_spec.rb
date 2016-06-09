describe Client do

  it { should belong_to(:account) }
  it { should have_many(:proposals).through(:account) }
  it { should have_many(:items).through(:proposals) }

end
