describe OauthAccount do

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should be_audited.associated_with(:user) }

end
