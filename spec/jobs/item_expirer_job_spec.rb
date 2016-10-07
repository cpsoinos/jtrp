describe ItemExpirerJob do

  let!(:good_items) { create_list(:item, 3, :consigned, listed_at: 91.days.ago) }
  let!(:bad_items) { create_list(:item, 2, :consigned, listed_at: 5.days.ago) }

  before do
    Item.all.each do |item|
      item.proposal.agreements.first.update_attribute("agreement_type", "consign")
    end
    allow(Item).to receive_message_chain(:consigned, :where).and_return(good_items)
  end

  it "marks items expired that have been active more than 90 days" do
    ItemExpirerJob.perform_later

    good_items.each do |item|
      expect(item).to be_expired
    end
    bad_items.each do |item|
      expect(item).not_to be_expired
    end
  end

end
