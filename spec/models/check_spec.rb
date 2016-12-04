describe Check do

  it { should be_audited.associated_with(:statement) }
  it { should belong_to(:statement) }
  it { should have_one(:account).through(:statement) }

end
