describe ScannedAgreement do

  it { should belong_to(:agreement) }
  it { should validate_presence_of(:agreement) }
  it { should validate_presence_of(:scan) }

end
