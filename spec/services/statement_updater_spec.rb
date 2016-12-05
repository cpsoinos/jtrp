describe StatementUpdater do

  let(:statement) { create(:statement) }
  let(:attrs) { { status: "paid", check_number: 123 } }
  let(:updater) { StatementUpdater.new(statement) }
  let(:sender) { double("sender") }

  it "can be instantiated" do
    expect(updater).to be_an_instance_of(StatementUpdater)
  end

  it "updates a statement" do
    allow(CheckSender).to receive(:new).and_return(sender)
    allow(sender).to receive(:send_check)
    updater.update(attrs)

    expect(statement).to be_paid
    expect(statement.check_number).to eq(123)
  end

end
