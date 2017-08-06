module Statements
  describe Creator do

    let(:account) { create(:account) }
    let(:service) { Statements::Creator.new(account) }

    it "can be instantiated" do
      expect(service).to be_an_instance_of(Statements::Creator)
    end

    it "creates a statement" do
      expect {
        service.create
      }.to change {
        Statement.count
      }.by(1)
    end

    it "sets the statement date" do
      Timecop.freeze(DateTime.parse("January 12, 2016 13:00")) do
        statement = service.create
        expect(statement.date.to_date.to_s).to eq(Date.today.to_s)
      end
    end

    it "creates the statement under the specified account" do
      statement = service.create
      expect(statement.account).to eq(account)
    end

    it "calls Statements::ItemGatherer" do
      gatherer = double("gatherer")
      allow(Statements::ItemGatherer).to receive(:new).and_return(gatherer)
      allow(gatherer).to receive(:execute)
      statement = service.create

      expect(Statements::ItemGatherer).to have_received(:new).with(statement, account)
      expect(gatherer).to have_received(:execute)
    end

  end
end
