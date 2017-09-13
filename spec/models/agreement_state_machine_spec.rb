describe AgreementStateMachine do

  before do
    allow(PdfGeneratorJob).to receive(:perform_later)
    allow(Notifier).to receive_message_chain(:send_agreement, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_agreement_active_notification, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_executed_agreement, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_agreement_pending_expiration, :deliver_later)
    allow(Notifier).to receive_message_chain(:send_agreement_expired, :deliver_later)
  end

  it "starts as 'potential'" do
    expect(Agreement.new(proposal: build_stubbed(:proposal))).to be_potential
  end

  it "transitions 'potential' to 'active'" do
    agreement = create(:agreement)
    items = create_list(:item, 3, proposal: agreement.proposal, client_intention: "sell", agreement: agreement)
    items.each do |item|
      expect(item.original_description).to eq(nil)
    end
    expect(agreement).to be_potential
    expect(agreement.proposal).to be_potential
    agreement.client_agreed = true
    agreement.mark_active

    expect(agreement).to be_active
    expect(agreement.proposal).to be_active
    expect(agreement.proposal.job).to be_active
    expect(agreement.proposal.account).to be_active
    expect(Notifier).to have_received(:send_executed_agreement).with(agreement)
    items.each do |item|
      item.reload
      expect(item.original_description).to eq(item.description)
    end
  end

  it "transitions 'active' to 'inactive'" do
    item = create(:item, :active, client_intention: "sell")
    agreement = item.agreement
    item.mark_sold
    agreement.reload

    expect(agreement).to be_inactive
  end

  it "does not transition 'active' to 'inactive' upon item sale if any other items still active" do
    agreement = create(:agreement, :active)
    items = create_list(:item, 2, :active, proposal: agreement.proposal, client_intention: "sell")

    expect {
      items.first.mark_sold
    }.not_to change {
      agreement.reload.status
    }
    expect(agreement).to be_active
  end

  it "does not transition 'active' to 'inactive' upon item sale if any other items still potential" do
    agreement = create(:agreement, :active)
    item = create(:item, :active, proposal: agreement.proposal, client_intention: "sell")
    item2 = create(:item, proposal: agreement.proposal, client_intention: "sell")

    expect {
      item.mark_sold
    }.not_to change {
      agreement.reload.status
    }
    expect(agreement).to be_active
  end

  it "transitions 'inactive' to 'active'" do
    agreement = create(:agreement, :inactive)
    agreement.mark_active

    expect(agreement).to be_active
  end

  it "does not auto-transition items to active when transitioning to active" do
    item = create(:item, client_intention: "sell")
    agreement = create(:agreement, proposal: item.proposal)
    agreement.client_agreed = true
    agreement.client_agreed_at = 3.minutes.ago
    agreement.save
    agreement.mark_active

    expect(item).not_to be_active
    expect(item).to be_potential
  end

end
