feature "proposal response" do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal, created_by: user) }
  let(:job) { proposal.job }
  let(:account) { job.account }
  let!(:items) { create_list(:item, 4, proposal: proposal, client_intention: "undecided") }
  let!(:intentions) { %w(sell consign decline undecided) }

  before do
    allow(TransactionalEmailJob).to receive(:perform_later)
    account.primary_contact = create(:client, account: account)
    items.first.update_attribute("will_purchase", true)
    items.second.update_attribute("will_consign", true)
  end

  context "internal user" do

    before do
      sign_in(user)
    end

    scenario "user chooses client intentions", js: true do
      visit account_job_proposal_path(account, job, proposal)
      items.each_with_index do |item, i|
        find(:css, "#item_#{item.id}_client_intention_#{intentions[i]}", visible: false).trigger("click")
        wait_for_ajax
        expect(item.reload.client_intention).to eq(intentions[i])
      end
    end

    context "creates client agreements" do

      scenario "one intention" do
        Item.update_all(client_intention: "sell")
        visit account_job_proposal_path(account, job, proposal)
        click_link("Generate Agreements")

        expect(page).to have_link("Purchase Order")
      end

      scenario "multiple intentions" do
        items.each_with_index do |item, i|
          item.update_attribute("client_intention", intentions[i])
        end
        visit account_job_proposal_path(account, job, proposal)
        click_link("Generate Agreements")

        expect(proposal.agreements.count).to eq(2)
        ["Purchase Order", "Consignment Agreement"].each do |agreement_type|
          expect(page).to have_link(agreement_type)
        end
      end
    end
  end

  context "client" do

    scenario "token not present" do
      visit account_job_proposal_path(account, job, proposal)

      expect(page).to have_content("You must be logged in to access this page!")
    end

    scenario "prior to introducing tokens" do
      proposal.update_attribute("created_at", DateTime.parse("October 1, 2016"))
      visit account_job_proposal_path(account, job, proposal)

      expect(page).not_to have_content("You must be logged in to access this page!")
    end

    scenario "user chooses client intentions", js: true do
      visit account_job_proposal_path(account, job, proposal, token: proposal.token)
      items.each_with_index do |item, i|
        find(:css, "#item_#{item.id}_client_intention_#{intentions[i]}", visible: false).trigger("click")
        wait_for_ajax
        item.reload
        expect(item.client_intention).to eq(intentions[i])
      end
    end

    scenario "sends a response to jtrp" do
      visit account_job_proposal_path(account, job, proposal, token: proposal.token)
      fill_in("note", with: "this is a note")
      click_button("Send Email")

      expect(TransactionalEmailJob).to have_received(:perform_later).with(proposal, account.primary_contact, user, "notification", "this is a note")
    end

  end

end
