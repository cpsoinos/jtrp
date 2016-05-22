feature "client show" do

  let(:user) { create(:internal_user) }

  context "internal user" do

    before do
      sign_in user
    end

    context "potential client" do

      let!(:client) { create(:client) }

      scenario "clicks through from client index" do
        visit clients_path(status: 'potential')
        click_link(client.full_name)

        expect(page).to have_content(client.full_name)
        expect(page).to have_content("Client")
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
        proposal = create(:proposal, client: client, created_by: user)
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

    context "active client" do

      let!(:client) { create(:client, :active) }
      let(:proposal) { client.proposals.first }
      let(:item) { proposal.items.first }

      before do
        item.update_attributes(client_intention: "sell", offer_type: "purchase", purchase_price_cents: 5500, listing_price_cents: 7500)
      end

      scenario "clicks through from client index" do
        visit clients_path(status: 'active')
        click_link(client.full_name)

        expect(page).to have_content(client.full_name)
        expect(page).to have_content("Client")
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
      end

      scenario "client has an active item" do
        visit client_path(client)

        expect(page).not_to have_content("No active items.")
        expect(page).to have_content("Purchased for $55.00")
        expect(page).to have_content("Listed for $75.00")
        expect(page).to have_content("No sold items.")

        expect(page).not_to have_content("No active proposals.")
        expect(page).to have_link("Proposal No. #{proposal.id}")
        expect(page).to have_content("No inactive proposals.")
      end

      scenario "client has a sold item" do
        create(:item, :sold, proposal: proposal, purchase_price_cents: 5500, sale_price_cents: 8500, client_intention: "sell", offer_type: "purchase")
        visit client_path(client)

        expect(page).not_to have_content("No active items.")
        expect(page).to have_content("Purchased for $55.00")
        expect(page).to have_content("Sold for $85.00")
        expect(page).to have_content("$30.00 in profit!")
        expect(page).not_to have_content("No sold items.")

        expect(page).not_to have_content("No active proposals.")
        expect(page).to have_link("Proposal No. #{proposal.id}")
        expect(page).to have_content("No inactive proposals.")
      end

    end

    context "inactive client" do

      let!(:client) { create(:client, :inactive) }
      let(:proposal) { client.proposals.first }
      let(:item) { proposal.items.first }

      before do
        item.update_attributes(client_intention: "sell", purchase_price_cents: 5500, minimum_sale_price_cents: 7500, sale_price_cents: 8500)
      end

      scenario "clicks through from client index" do
        visit clients_path(status: 'inactive')
        click_link(client.full_name)

        expect(page).to have_content(client.full_name)
        expect(page).to have_content("Client")
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
      end

      scenario "client has a sold item" do
        visit client_path(client)

        expect(page).to have_content("No active items.")
        expect(page).to have_content("Sold for $85.00")
        expect(page).not_to have_content("No sold items.")

        expect(page).to have_content("No active proposals.")
        expect(page).to have_link("Proposal No. #{proposal.id}")
        expect(page).not_to have_content("No inactive proposals.")
      end

    end

  end

end
