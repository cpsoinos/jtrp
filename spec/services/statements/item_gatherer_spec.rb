module Statements
  describe ItemGatherer do

    let(:date) { DateTime.parse("July 1, 2017 13:00") }
    let(:statement) { create(:statement, date: date) }
    let(:account) { statement.account }
    let(:job) { create(:job, account: account) }
    let(:proposal) { create(:proposal, job: job) }
    let!(:items) { create_list(:item, 4, :sold, sold_at: (date - 5.days), client_intention: "consign", proposal: proposal) }
    let!(:item) { create(:item, sold_at: DateTime.now) }
    let(:service) { Statements::ItemGatherer.new(statement, account) }

    it "can be instantiated" do
      expect(service).to be_an_instance_of(Statements::ItemGatherer)
    end

    it "creates statement_items" do
      expect {
        service.execute
      }.to change {
        StatementItem.count
      }.by(4)
    end

    it "gathers sold consignment items from the specified account for the correct time period" do
      service.execute

      expect(statement.items).to match_array(items)
      expect(item).not_to be_in(statement.items)
    end

  end
end
