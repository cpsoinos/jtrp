feature "proposal response" do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let(:job) { proposal.job }
  let(:account) { job.account }
  let!(:items) { create_list(:item, 5, proposal: proposal) }
  let!(:intentions) { %w(sell consign donate dump nothing) }

  before do
    allow(TransactionalEmailJob).to receive(:perform_later)
    account.primary_contact = create(:client, account: account)
    items.first.update_attribute("will_purchase", true)
    items.second.update_attribute("will_consign", true)
    visit account_job_proposal_path(account, job, proposal)
  end

  context "internal user" do

    before do
      sign_in(user)
    end

    scenario "user chooses client intentions", js: true do
      items.each_with_index do |item, i|
        find(:css, "#item_#{item.id}_client_intention_#{intentions[i]}", visible: false).trigger("click")
        wait_for_ajax
        item.reload
        expect(item.client_intention).to eq(intentions[i])
      end
    end

    context "creates client agreements" do

      before do
        Company.first.update_attribute("primary_contact_id", user.id)
      end

      scenario "one intention" do
        Item.update_all(client_intention: "sell")
        click_link("Generate Agreements")

        expect(page).to have_link("sell")
      end

      scenario "multiple intentions" do
        items.each_with_index do |item, i|
          item.update_attribute("client_intention", intentions[i])
        end
        click_link("Generate Agreements")

        intentions.each do |intention|
          expect(page).to have_link(intention) unless intention == "nothing"
        end
      end
    end
  end

  context "client" do

    scenario "sends a response to jtrp" do
      save_and_open_page
      click_button("I'm Finished!")
      fill_in("note", with: "this is a note")
      click_button("Send Email")

      expect(TransactionalEmailJob).to have_received(:perform_later).with(proposal, account.primary_contact, user, "notification", "this is a note")
    end

  end

end
