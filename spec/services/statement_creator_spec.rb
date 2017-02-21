describe StatementCreator do

  let(:account) { create(:account) }
  let(:service) { StatementCreator.new(account) }

  it "can be instantiated" do
    expect(service).to be_an_instance_of(StatementCreator)
  end

  it "creates a statement" do
    expect {
      service.create
    }.to change {
      Statement.count
    }.by(1)
  end

  it "sets the statement date" do
    Timecop.freeze(DateTime.parse("January 12, 2016 13:00"))
    statement = service.create
    expect(statement.date.to_date.to_s).to eq(Date.today.to_s)
    Timecop.return
  end

  it "creates the statement under the specified account" do
    statement = service.create
    expect(statement.account).to eq(account)
  end

end
