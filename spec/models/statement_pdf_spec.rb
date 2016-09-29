describe StatementPdf do

  it { should be_audited.associated_with(:statement) }
  it { should belong_to(:statement) }

end
