describe StatementJob do

  let!(:agreements) { create_list(:agreement, 3, :active, :consign) }
  let!(:expired_agreement) { create(:agreement, :inactive, :consign) }

  before do
    Timecop.freeze(DateTime.parse("October 1, 2016 08:00"))
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.first.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.second.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: agreements.third.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, expired: true, proposal: expired_agreement.proposal)
    create(:item, :sold, client_intention: "consign", sale_price_cents: 5000, sold_at: 15.days.ago, proposal: create(:proposal, :active, job: create(:job, account: agreements.third.account)))
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

  it "does not create a statement for an account with only expired items" do
    StatementJob.perform_later

    expect(expired_agreement.account.id).not_to be_in(Statement.pluck(:account_id))
  end

end
