describe StatementUpdater do

  let(:statement) { create(:statement) }
  let(:attrs) { { status: "paid", check_number: 123 } }
  let(:updater) { StatementUpdater.new(statement) }

  it "can be instantiated" do
    expect(updater).to be_an_instance_of(StatementUpdater)
  end

  it "updates a statement" do
    updater.update(attrs)

    expect(statement).to be_paid
    expect(statement.check_number).to eq(123)
  end

end
