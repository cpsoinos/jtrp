describe StatementCreator do

  let(:agreement) { create(:agreement) }
  let(:service) { StatementCreator.new(agreement) }

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
    Timecop.freeze
    statement = service.create
    expect(statement.date.to_date.to_s).to eq(Date.today.to_s)
    Timecop.return
  end

  it "creates the statement under the specified agreement" do
    statement = service.create
    expect(statement.agreement).to eq(agreement)
  end

end
