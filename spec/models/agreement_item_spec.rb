describe AgreementItem do

  it { should belong_to(:agreement) }
  it { should belong_to(:item) }

  it { should validate_presence_of(:agreement) }
  it { should validate_presence_of(:item) }

end
