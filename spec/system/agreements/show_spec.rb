describe 'agreement' do
  let(:user) { create(:internal_user) }
  let(:account) { create(:account, :with_client) }
  let(:client) { account.primary_contact }
  let(:job) { create(:job, account: account) }
  let(:proposal) { create(:proposal, created_by: user, job: job) }
  let(:syncer) { double('syncer') }

  before do
    allow(PdfGeneratorJob).to receive(:perform_later).and_return(true)
    # company = Company.jtrp
    # company.primary_contact = create(:internal_user)
    # company.save
    allow(LetterSenderJob).to receive(:perform_later).and_return(true)
    allow(ItemExpirerJob).to receive(:perform_later).and_return(true)
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
    allow(syncer).to receive(:remote_destroy).and_return(true)
    allow(Notifier).to receive_message_chain(:send_executed_agreement, :deliver_later)
  end

  context 'guest' do
    scenario 'visits consignment agreement path' do
      visit account_job_proposal_agreements_path(account, job, proposal)

      expect(page).to have_content('You must be logged in to access this page!')
    end
  end

  context 'internal user' do
    before do
      sign_in(user)
    end

    context 'sell' do
      let!(:item) { create(:item, proposal: proposal, client_intention: 'sell') }
      let!(:agreement) { create(:agreement, :sell, proposal: proposal) }

      scenario 'client intends to sell an item', js: true do
        visit account_job_proposal_agreements_path(account, job, proposal)

        expect(page).not_to have_link('consign')
        expect(page).not_to have_link('dump')
        expect(page).not_to have_link('donate')

        expect(page).to have_content("Purchase Invoice")
      end

      scenario 'activates items from index', js: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active

        visit account_job_proposal_agreements_path(account, job, proposal)
        click_link('Purchase Invoice')
        within('.dropup') do
          click_on('menu')
        end
        click_on('Mark Items Active')

        expect(page).to have_content('Items are marked active!')
        expect(item.reload).to be_active
      end

      scenario 'activates items from show' do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active

        visit agreement_path(agreement)
        within('.dropup') do
          click_on('menu')
        end
        click_on('Mark Items Active')

        expect(page).to have_content('Items are marked active!')
        expect(item.reload).to be_active
      end

      scenario "can't try to activate items from index when items already active", js: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active
        item.mark_active

        visit account_job_proposal_agreement_path(account, job, proposal, agreement)
        within('.dropup') do
          click_on('menu')
        end

        expect(page).not_to have_button('Mark Items Active')
      end

      scenario "can't try to activate items from show when items already active" do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active
        item.mark_active

        visit agreement_path(agreement)
        within('.dropup') do
          click_on('menu')
        end

        expect(page).not_to have_button('Mark Items Active')
      end
    end

    context 'consign' do
      let!(:item) { create(:item, proposal: proposal, client_intention: 'consign') }
      let!(:agreement) { create(:agreement, :consign, proposal: proposal) }

      before do
        # Company.first.update_attribute('primary_contact_id', user.id)
        allow(syncer).to receive(:remote_create).and_return(true)
      end

      scenario 'visits consignment agreement path' do
        visit account_job_proposal_agreements_path(account, job, proposal)
        expect(page).not_to have_link('sell')
        expect(page).not_to have_link('dump')
        expect(page).not_to have_link('donate')

        expect(page).to have_content('Consignment Agreement')
      end

      scenario 'activates items from index', js: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active

        visit account_job_proposal_agreement_path(account, job, proposal, agreement)
        within('.dropup') do
          click_on('menu')
        end
        click_on('Mark Items Active')

        expect(page).to have_content('Items are marked active!')
        expect(item.reload).to be_active
      end

      scenario "can't try to activate items when items already active", js: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
        agreement.mark_active
        item.mark_active

        visit account_job_proposal_agreement_path(account, job, proposal, agreement)
        within('.dropup') do
          click_on('menu')
        end

        expect(page).not_to have_button('Mark Items Active')
      end

      scenario 'expires items from index', js: true, skip: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute('listed_at', 91.days.ago)

        visit account_job_proposal_agreement_path(account, job, proposal, agreement)
        within('.dropup') do
          click_button('menu')
        end
        click_on('Mark Items Expired')

        expect(page).to have_field('Expiration Pending', visible: false)
        expect(page).to have_field('Expire Agreement', visible: false)

        within('#expired') do
          first(:css, '.circle').click
          sleep(1)
        end
        fill_in('note', with: 'Personalized message goes here')
        click_button('Notify Client')

        expect(page).to have_content('Email and letter queued for delivery', wait: 3)
        expect(page).to have_content('Success!')

        expect(ItemExpirerJob).to have_received(:perform_later)
      end

      scenario 'expires items from show', js: true, skip: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        agreement.reload
        item.mark_active
        item.update_attribute('listed_at', 91.days.ago)
        item.reload

        visit agreement_path(agreement.reload)
        within('.dropup') do
          click_on('menu')
        end
        click_on('Mark Items Expired')

        expect(page).to have_field('Expiration Pending', visible: false)
        expect(page).to have_field('Expire Agreement', visible: false)

        within('#expired') do
          first(:css, '.circle').click
        end
        fill_in('note', with: 'Personalized message goes here')
        click_button('Notify Client')

        expect(page).to have_content('Email and letter queued for delivery', wait: 5)
        expect(page).to have_content('Success!')

        expect(ItemExpirerJob).to have_received(:perform_later)
      end

      scenario "can't try to expire items from index when items already expired", js: true do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute('listed_at', 91.days.ago)
        item.mark_expired

        visit account_job_proposal_agreements_path(account, job, proposal)

        expect(page).not_to have_button('Mark Items Expired')
      end

      scenario "can't try to expire items from show when items already expired" do
        agreement.update_attributes(client_agreed: true, client_agreed_at: 91.days.ago, date: 91.days.ago)
        agreement.mark_active
        item.mark_active
        item.update_attribute('listed_at', 91.days.ago)
        item.mark_expired
        visit agreement_path(agreement)

        expect(page).not_to have_button('Mark Items Expired')
      end

      context "deactivate agreement" do

        scenario "successfully deactivates an agreement" do
          agreement.update_attributes(client_agreed: true)
          agreement.mark_active
          item.mark_active
          visit agreement_path(agreement)
          within(".fab-menu-button") do
            click_on("menu")
          end
          click_link("Deactivate")

          expect(page).to have_content("Agreement deactivated")
        end

        scenario "agreement has potential items" do
          agreement.update_attributes(client_agreed: true)
          agreement.mark_active
          visit agreement_path(agreement)
          within(".fab-menu-button") do
            click_on("menu")
          end
          click_link("Deactivate")

          expect(page).to have_content("Agreement deactivated")
        end

        scenario "agreement has both potential and active items" do
          agreement.update_attributes(client_agreed: true)
          agreement.items << create(:item, proposal: proposal, client_intention: 'consign')
          agreement.mark_active
          item.mark_active
          visit agreement_path(agreement)
          within(".fab-menu-button") do
            click_on("menu")
          end
          click_link("Deactivate")

          expect(page).to have_content("Agreement deactivated")
          agreement.reload
          expect(agreement.items.pluck(:status)).to match(['inactive', 'inactive'])
        end

      end

    end
  end

  context 'client' do
    let!(:item) { create(:item, proposal: proposal, client_intention: 'consign') }
    let!(:agreement) { create(:agreement, :consign, proposal: proposal) }

    before do
      allow(PdfGeneratorJob).to receive(:perform_later)
      allow(TransactionalEmailJob).to receive(:perform_later)
      allow(InventorySync).to receive(:new).and_return(syncer)
    end

    scenario 'token not present' do
      visit account_job_proposal_agreement_path(account, job, proposal, agreement)

      expect(page).to have_content('You must be logged in to access this page!')
    end

    scenario 'prior to introducing tokens' do
      agreement.update_attribute('created_at', DateTime.parse('October 1, 2016'))
      visit account_job_proposal_agreement_path(account, job, proposal, agreement)

      expect(page).not_to have_content('You must be logged in to access this page!')
    end

    scenario 'there is legal verbiage around the clickwrap' do
      visit account_job_proposal_agreement_path(account, job, proposal, agreement, token: agreement.token)

      expect(page).to have_content('By checking the box below and accepting this agreement, you signify your acceptance of our terms. You will receive a copy of the executed agreement by email upon accepting.')
    end

    scenario 'client agrees' do
      Timecop.freeze(Time.now) do
        visit account_job_proposal_agreement_path(account, job, proposal, agreement, token: agreement.token)
        first('input[name="agreement[client_agreed]"]', visible: :false).set(true)
        click_button('I Accept')
        agreement.reload

        # expect(page).to have_content("#{account.full_name} accepted the terms of this agreement at #{DateTime.now.strftime('%l:%M %p on %B %d, %Y')}.")
        expect(agreement.client_agreed).to be(true)
      end
    end

    scenario "client doesn't see 'Mark Items Active' button from show" do
      agreement.update_attributes(client_agreed: true, client_agreed_at: 3.minutes.ago, date: 3.minutes.ago)
      agreement.mark_active

      visit agreement_path(agreement, token: agreement.token)

      expect(page).not_to have_button('Mark Items Active')
    end
  end
end
