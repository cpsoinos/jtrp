feature "client show" do

  let(:user) { create(:internal_user) }
  let(:client) { create(:client) }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits show page" do
      visit client_path(client)

      expect(page).to have_content(client.full_name)
      expect(page).to have_content("Client")
      expect(page).to have_content(client.address_1)
      expect(page).to have_content(client.address_2)
      expect(page).to have_content(client.city)
      expect(page).to have_content(client.state)
      expect(page).to have_content(client.zip)

      expect(page).to have_selector("img[alt$='Client Avatar']")
      expect(page).to have_selector("img[alt$='Client Address']")

      ["Potential Items", "Active Items", "Sold Items", "Potential Proposals", "Active Proposals", "Inactive Proposals"].each do |section|
        expect(page).to have_content(section)
        expect(page).to have_content("No #{section.downcase}.")
      end
    end

    scenario "client has some potential items" do
      proposal = create(:proposal, job: create(:job, account: client.account), created_by: user)
      items = create_list(:item, 2, :with_initial_photo, proposal: proposal)
      items.first.update_attribute("offer_type", "consign")
      items.last.update_attribute("client_intention", "sell")

      visit client_path(client)

      expect(page).to have_content("Potential Items")
      expect(page).not_to have_content("No potential items.")
      expect(page).to have_content("Offer: consign")

      expect(page).to have_content("Potential Proposals")
      expect(page).not_to have_content("No potential proposals.")
      expect(page).to have_link("Proposal No. #{proposal.id}")

      expect(page).to have_content("No active items.")
      expect(page).to have_content("No sold items.")
      expect(page).to have_content("No active proposals.")
      expect(page).to have_content("No inactive proposals.")
    end

  end

end
