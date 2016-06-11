feature "proposal response" do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let(:job) { proposal.job }
  let(:account) { job.account }
  let!(:items) { create_list(:item, 6, proposal: proposal) }
  let!(:intentions) { %w(sell consign donate dump move nothing) }

  before do
    account.primary_contact = create(:client, account: account)
  end

  context "guest" do
    scenario "visits consignment agreement path" do
      visit account_job_proposal_response_form_path(account, job, proposal)

      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in(user)
      visit account_job_proposal_response_form_path(account, job, proposal)
    end

    scenario "user chooses client intentions", js: true do
      items.each_with_index do |item, i|
        choose("item_#{item.id}_client_intention_#{intentions[i]}")
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

end
