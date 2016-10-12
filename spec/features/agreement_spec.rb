feature "agreement" do

  let(:user) { create(:internal_user) }
  let(:account) { create(:account, :with_client) }
  let(:client) { account.primary_contact }
  let(:job) { create(:job, account: account) }
  let(:proposal) { create(:proposal, created_by: user, job: job) }
  let(:syncer) { double("syncer") }

  before do
    allow(TransactionalEmailJob).to receive(:perform_later)
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
    allow(syncer).to receive(:remote_destroy).and_return(true)
  end

  context "guest" do
    scenario "visits consignment agreement path" do
      visit account_job_proposal_agreements_path(account, job, proposal)

      expect(page).to have_content("You must be logged in to access this page!")
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
        visit account_job_proposal_agreements_path(account, job, proposal)

        expect(page).not_to have_link("consign")
        expect(page).not_to have_link("dump")
        expect(page).not_to have_link("donate")

        click_link("sell")

        expect(page).to have_content("Purchase Invoice")
      end

      scenario "item original description is displayed on agreements", js: true do
        item.update_attribute("description", "new description")
        item.reload
        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("sell")

        expect(page).to have_content(item.original_description)
        expect(page).not_to have_content("new description")
      end

      scenario "uploads scanned agreement", js: true do
        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("sell")
        attach_file('scanned_agreement[scan]', File.join(Rails.root, '/spec/fixtures/test.pdf'))
        click_on("Create Scanned agreement")

        expect(page).to have_selector('iframe')
        expect(agreement.reload).to be_active
      end

      scenario "uploads an updated scanned agreement", js: true do
        scanned_agreement = create(:scanned_agreement)
        agreement = scanned_agreement.agreement

        visit account_job_proposal_agreements_path(agreement.account, agreement.job, agreement.proposal)
        click_link("sell")
        attach_file('scanned_agreement[scan]', File.join(Rails.root, '/spec/fixtures/test.pdf'))
        click_on("Update Scanned agreement")

        expect(page).to have_content("Agreement updated!")
        expect(page).to have_selector('iframe')
        expect(agreement.reload).to be_active
      end

      scenario "activates items from index", js: true do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active

        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("sell")
        click_on("Mark Items Active")

        expect(page).to have_content("Items are marked active!")
        expect(item.reload).to be_active
      end

      scenario "activates items from show" do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active

        visit agreement_path(agreement)
        click_on("Mark Items Active")

        expect(page).to have_content("Items are marked active!")
        expect(item.reload).to be_active
      end

      scenario "can't try to activate items from index when items already active", js: true do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active
        item.mark_active

        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("sell")

        expect(page).not_to have_button("Mark Items Active")
      end

      scenario "can't try to activate items from show when items already active" do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active
        item.mark_active
        visit agreement_path(agreement)

        expect(page).not_to have_button("Mark Items Active")
      end

    end

    context "consign" do

      let!(:item) { create(:item, proposal: proposal, client_intention: "consign") }
      let!(:agreement) { create(:agreement, :consign, proposal: proposal) }
      let(:syncer) { double("syncer") }

      before do
        Company.first.update_attribute("primary_contact_id", user.id)
        allow(InventorySync).to receive(:new).and_return(syncer)
        allow(syncer).to receive(:remote_create).and_return(true)
        visit account_job_proposal_agreements_path(account, job, proposal)
      end

      before :each, js: true do
        page.execute_script("$($('a[role=tab]')[0]).tab('show');")
      end

      scenario "visits consignment agreement path" do
        expect(page).not_to have_link("sell")
        expect(page).not_to have_link("dump")
        expect(page).not_to have_link("donate")

        click_link("consign")

        expect(page).to have_content("Consignment Agreement")
      end

      scenario "manager agrees", skip: "not requiring manager signature", js: true do
        first('input[name="agreement[manager_agreed]"]', visible: :false).set(true)
        click_button("consign-manager-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.manager_agreed).to be(true)
      end

      scenario "both client and manager sign", js: true do
        pending("client portal")
        first('input[name="agreement[manager_agreed]"]', visible: :false).set(true)
        click_button("consign-manager-submit")
        first('input[name="agreement[client_agreed]"]', visible: :false).set(true)
        click_button("consign-client-submit")
        wait_for_ajax
        agreement.reload

        expect(agreement.client_agreed).to be(true)
        expect(agreement.manager_agreed).to be(true)
        expect(agreement).to be_active
      end

      scenario "activates items from index", js: true do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active

        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("consign")
        click_on("Mark Items Active")

        expect(page).to have_content("Items are marked active!")
        expect(item.reload).to be_active
      end

      scenario "can't try to activate items when items already active", js: true do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active
        item.mark_active

        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link("consign")

        expect(page).not_to have_button("Mark Items Active")
      end

      scenario "expires items from index" do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        allow(ItemExpirerJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute("listed_at", 91.days.ago)

        visit account_job_proposal_agreements_path(account, job, proposal)
        click_on("Mark Items Expired")

        expect(ItemExpirerJob).to have_received(:perform_later)
        expect(page).to have_content("Items have been queued to be expired! They will appear under the JTRP account shortly.")
      end

      scenario "expires items from show" do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        allow(ItemExpirerJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute("listed_at", 91.days.ago)

        visit agreement_path(agreement)
        click_on("Mark Items Expired")

        expect(ItemExpirerJob).to have_received(:perform_later)
        expect(page).to have_content("Items have been queued to be expired! They will appear under the JTRP account shortly.")
      end

      scenario "can't try to expire items from index when items already expired", js: true do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        allow(ItemExpirerJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute("listed_at", 91.days.ago)
        item.mark_expired

        visit account_job_proposal_agreements_path(account, job, proposal)

        expect(page).not_to have_button("Mark Items Expired")
      end

      scenario "can't try to expire items from show when items already expired" do
        allow(PdfGeneratorJob).to receive(:perform_later)
        allow(InventorySyncJob).to receive(:perform_later)
        allow(ItemExpirerJob).to receive(:perform_later)
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute("listed_at", 91.days.ago)
        item.mark_expired
        visit agreement_path(agreement)

        expect(page).not_to have_button("Mark Items Expired")
      end

    end

  end

  context "client" do

    let!(:item) { create(:item, proposal: proposal, client_intention: "consign") }
    let!(:agreement) { create(:agreement, :consign, proposal: proposal) }

    before do
      allow(PdfGeneratorJob).to receive(:perform_later)
      allow(TransactionalEmailJob).to receive(:perform_later)
      allow(InventorySync).to receive(:new).and_return(syncer)
    end

    scenario "token not present" do
      visit account_job_proposal_agreement_path(account, job, proposal, agreement)

      expect(page).to have_content("You must be logged in to access this page!")
    end

    scenario "there is legal verbiage around the clickwrap" do
      visit account_job_proposal_agreement_path(account, job, proposal, agreement, token: agreement.token)

      expect(page).to have_content("By checking the box below and accepting this agreement, you signify your acceptance of our terms. You will receive a copy of the executed agreement by email upon accepting.")
    end

    scenario "client agrees" do
      Timecop.freeze(Time.now)
      visit account_job_proposal_agreement_path(account, job, proposal, agreement, token: agreement.token)
      first('input[name="agreement[client_agreed]"]', visible: :false).set(true)
      click_button("I Accept")
      agreement.reload

      expect(page).to have_content("#{account.full_name} accepted the terms of this agreement at #{DateTime.now.strftime('%l:%M %p on %B %d, %Y')}.")
      expect(agreement.client_agreed).to be(true)
      Timecop.return
    end

    scenario "client doesn't see 'Mark Items Active' button from show" do
      allow(PdfGeneratorJob).to receive(:perform_later)
      allow(InventorySyncJob).to receive(:perform_later)
      agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
      agreement.mark_active

      visit agreement_path(agreement, token: agreement.token)

      expect(page).not_to have_button("Mark Items Active")
    end

  end

end
