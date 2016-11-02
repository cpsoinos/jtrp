describe StatementJob do

  let!(:agreements) { create_list(:agreement, 3, :active, :consign) }

  before do
    Timecop.freeze(DateTime.parse("October 1, 2016 08:00"))
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.first.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.second.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.third.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.third.proposal)
  end

  after do
    Timecop.return
  end

  it "perform" do
    expect {
      StatementJob.perform_later
    }.to change {
      Statement.count
    }.by (3)
  end

end
