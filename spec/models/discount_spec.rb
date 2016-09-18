describe Order do

  it { should belong_to(:item) }
  it { should belong_to(:order) }

end
