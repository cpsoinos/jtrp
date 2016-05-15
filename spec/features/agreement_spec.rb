feature "agreement" do

  let(:client) { create(:client) }
  let(:user) { create(:internal_user, company: Company.first, primary_contact: true) }
  let(:proposal) { create(:proposal, created_by: user, client: client) }

  context "guest" do
    scenario "visits consignment agreement path" do
      visit proposal_agreements_path(proposal)

      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in(user)
    end

    context "sell" do

      let!(:item) { create(:item, proposal: proposal, client_intention: "sell") }
      let!(:agreement) { create(:agreement, :sell, proposal: proposal) }

      scenario "client intends to sell an item", js: true do
        visit proposal_agreements_path(proposal)
        click_link("sell")

        expect(page).to have_content("Purchase Invoice")
      end

    end

    context "consign" do

      let!(:item) { create(:item, proposal: proposal, client_intention: "consign") }
      let!(:agreement) { create(:agreement, :consign, proposal: proposal) }

      before do
        visit proposal_agreements_path(proposal)
      end

      before :each, js: true do
        page.execute_script("$($('a[role=tab]')[0]).tab('show');")
        page.execute_script("handleSignatures();")
      end

      scenario "visits consignment agreement path" do
        click_link("consign")

        expect(page).to have_content("Consignment Agreement")
      end

      scenario "it has signature blocks" do
        expect(page).to have_css('#consign-client-signed')
        expect(page).to have_css('#consign-manager-signed')
      end

      scenario "manager signs", js: true do
        find(".consign-manager-signed").click
        click_button("consign-manager-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.manager_signature).not_to be(nil)
      end

      scenario "client signs", js: true do
        find(".consign-client-signed").click
        click_button("consign-client-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.client_signature).not_to be(nil)
      end

      scenario "both client and manager sign", js: true do
        find(".consign-manager-signed").click
        click_button("consign-manager-submit")
        find(".consign-client-signed").click
        click_button("consign-client-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.client_signature).not_to be(nil)
        expect(agreement.manager_signature).not_to be(nil)
        expect(agreement.state).to eq("active")
      end

    end

  end

end
