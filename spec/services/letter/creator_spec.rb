describe Letter::Creator do

  let(:agreement) { create(:agreement) }
  let(:creator) { Letter::Creator.new(agreement) }

  it "can be instantiated" do
    expect(creator).to be_an_instance_of(Letter::Creator)
  end

  it "creates a letter" do
    expect {
      creator.create_letter("example_category")
    }.to change {
      Letter.count
    }.by (1)
  end

  it "creates a letter for the right account" do
    account = agreement.account

    expect {
      creator.create_letter("example_category")
    }.to change {
      account.letters.count
    }.by (1)
  end

  it "creates a letter with the right category" do
    letter = creator.create_letter("example_category")

    expect(letter.category).to eq("example_category")
  end

end
