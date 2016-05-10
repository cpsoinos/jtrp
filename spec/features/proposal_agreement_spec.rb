feature "proposal agreement" do

  let(:client) { create(:client) }
  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal, created_by: user, client: client) }

  context "guest" do
    scenario "visits consignment agreement path" do
      visit proposal_consignment_agreement_path(proposal)

      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in(user)
    end

    context "sell" do

      let(:item) { create(:item, proposal: proposal, client_intention: "sell") }

      scenario "client intends to sell an item", js: true do
        visit proposal_path(proposal)
        click_link("View Proposal")

        expect(page).to have_content("")
      end

    end

    context "consign" do

      before do
        visit proposal_consignment_agreement_path(proposal)
      end

      scenario "visits consignment agreement path" do
        expect(page).to have_content("Consignment Agreement")
      end

      scenario "it has signature blocks" do
        expect(page).to have_css('#client-signed')
        expect(page).to have_css('#manager-signed')
      end

      scenario "manager signs", js: true do
        find(".manager-signed").click
        click_button("manager-submit")
        wait_for_ajax
        proposal.reload

        expect(proposal.manager_signature).not_to be(nil)
      end

      scenario "client signs", js: true do
        find(".client-signed").click
        click_button("client-submit")
        wait_for_ajax
        proposal.reload

        expect(proposal.client_signature).not_to be(nil)
      end

      scenario "both client and manager sign", js: true do
        find(".manager-signed").click
        click_button("manager-submit")
        find(".client-signed").click
        click_button("client-submit")
        wait_for_ajax
        proposal.reload

        expect(proposal.client_signature).not_to be(nil)
        expect(proposal.manager_signature).not_to be(nil)
      end

    end

  end

end
