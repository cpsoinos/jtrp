describe StatementItem do

  it { should belong_to(:statement) }
  it { should belong_to(:item) }

  it { should validate_presence_of(:statement) }
  it { should validate_presence_of(:item) }

end
