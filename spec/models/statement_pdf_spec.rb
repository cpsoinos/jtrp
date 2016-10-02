describe StatementPdf do

  it_should_behave_like Streamable

  it { should be_audited.associated_with(:statement) }
  it { should belong_to(:statement) }

end
