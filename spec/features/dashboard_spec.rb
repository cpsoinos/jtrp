feature "dashboard" do

  let(:user) { create(:internal_user) }
  let!(:item) { create(:item, :active, description: "abc12345", listing_price_cents: nil) }
  let(:syncer) { double("syncer") }

  before do
    sign_in(user)
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
  end

  it "has navigation links" do
    visit dashboard_path

    expect(page).to have_link("Items")
    expect(page).to have_link("Accounts")
    expect(page).to have_link("Jobs")
  end

  it "has information panels" do
    visit dashboard_path

    expect(page).to have_content("Sales")
    expect(page).to have_content("revenue measured daily")
    expect(page).to have_content("Customers")
    expect(page).to have_content("new customers measured daily")
    expect(page).to have_content("Clients")
    expect(page).to have_content("new clients measured monthly")
  end

  context "to do list" do

    it "has a to do list" do
      visit dashboard_path
      expect(page).to have_content("Tasks")
      expect(page).to have_content(item.description)
      expect(page).to have_content("needs a price added")
    end

    scenario "completes a to do list item", js: true do
      visit dashboard_path
      expect(page).to have_content("needs a price added")
      first(:link, "done").click
      expect(page).to have_content("SKU: #{item.id}")
      expect(page).to have_field("item[listing_price]")

      fill_in("item[listing_price]", with: "12.34")
      click_button("Update Item")

      expect(page).to have_content("#{item.description} updated!", wait: 3)
      expect(page).not_to have_content("needs a price added")
      item.reload
      expect(item.listing_price_cents).to eq(1234)
    end

    scenario "closes a to do list modal without completing", js: true do
      visit dashboard_path
      first(:link, "done").click
      click_button("×")

      expect(page).to have_field("item[listing_price]", visible: false)
      expect(page).to have_content("#{item.description} needs a price added")
    end

    context "agreements" do

      let!(:item) { create(:item, :consigned, listed_at: 85.days.ago) }
      let!(:agreement) { item.agreement }

      before do
        allow(TransactionalEmailJob).to receive(:perform_later).and_return(true)
        allow(LetterSenderJob).to receive(:perform_later).and_return(true)
        allow(ItemExpirerJob).to receive(:perform_later).and_return(true)
      end

      scenario "consignment period coming to an end" do
        visit dashboard_path
        expect(page).to have_content("#{agreement.account.full_name} needs to be notified that their consignment period is ending soon")
      end

      scenario "notifies client of pending expiration", js: true do
        visit dashboard_path
        within(".card-nav-tabs") do
          click_link("Agreements")
        end
        first(:link, "done").click

        expect(page).to have_content("has items that have been active for #{(DateTime.now.to_date - (agreement.items.where.not(listed_at: nil).order(:listed_at).first.listed_at.to_date)).to_i} days")
        expect(page).to have_field("Expiration Pending", visible: false)
        expect(page).to have_field("Expire Agreement", visible: false)

        within("#expiration-pending") do
          first(:css, ".circle").trigger("click")
        end
        fill_in("note", with: "Personalized message goes here")
        click_button("Notify Client")

        expect(page).to have_content("Email and letter queued for delivery", wait: 3)
        expect(page).to have_content("Success!")
        expect(page).not_to have_content("#{agreement.account.full_name} needs to be notified that their consignment period is ending soon")
      end

      scenario "notifies client of expired agreement", js: true do
        item.update_attribute("listed_at", 91.days.ago)

        visit dashboard_path
        within(".card-nav-tabs") do
          click_link("Agreements")
        end
        first(:link, "done").click

        expect(page).to have_content("has items that have been active for #{(DateTime.now.to_date - (agreement.items.where.not(listed_at: nil).order(:listed_at).first.listed_at.to_date)).to_i} days")
        expect(page).to have_field("Expiration Pending", visible: false)
        expect(page).to have_field("Expire Agreement", visible: false)

        within("#expired") do
          first(:css, ".circle").trigger("click")
        end
        fill_in("note", with: "Personalized message goes here")
        click_button("Notify Client")

        expect(page).to have_content("Email and letter queued for delivery", wait: 3)
        expect(page).to have_content("Success!")
        expect(page).not_to have_content("#{agreement.account.full_name} needs to be notified that their consignment period is ending soon")
      end

      scenario "does not choose a category", js: true, skip: true do
        Capybara.using_driver(:chrome) do
          visit dashboard_path
          within(".card-nav-tabs") do
            click_link("Agreements")
          end
          first(:link, "done").click
          click_on("Notify Client")

          expect(page).to have_content("Error")
          expect(page).to have_content("Category can't be blank")
          expect(page).to have_content("#{agreement.account.full_name} needs to be notified that their consignment period is ending soon")
        end
      end

      scenario "tags an agreement as unexpireable", js: true do
        visit dashboard_path
        within(".card-nav-tabs") do
          click_link("Agreements")
        end
        first(:link, "done").click
        click_button("Unexpireable")

        expect(page).to have_content("Note:")
        expect(page).to have_content("Agreement tagged as unexpireable.")
        expect(agreement.reload.tag_list).to include("unexpireable")
      end

    end
  end

  context "activity feed" do

    let(:user) { create(:internal_user) }
    let(:account) { create(:account, :with_client) }
    let(:agreement) { create(:agreement) }
    let(:category) { create(:category) }
    let(:client) { create(:client) }
    let(:item) { create(:item) }
    let(:job) { create(:job) }
    let(:letter) { create(:letter) }
    let(:proposal) { create(:proposal) }
    let(:statement) { create(:statement) }

    scenario "account created" do
      account.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created an account")
      expect(page).to have_link(account.full_name)
    end

    scenario "account updated" do
      account.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated an account")
      expect(page).to have_link(account.full_name)
    end

    scenario "agreement created" do
      agreement.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created an agreement")
      expect(page).to have_link("#{agreement.account.full_name} - #{agreement.humanized_agreement_type}")
    end

    scenario "agreement updated" do
      agreement.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated an agreement")
      expect(page).to have_link("#{agreement.account.full_name} - #{agreement.humanized_agreement_type}")
    end

    scenario "category created" do
      category.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created a category")
      expect(page).to have_link(category.name.titleize)
    end

    scenario "category updated" do
      category.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated a category")
      expect(page).to have_link(category.name.titleize)
    end

    scenario "client created" do
      client.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created a client")
      expect(page).to have_link(client.full_name)
    end

    scenario "client updated" do
      client.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated a client")
      expect(page).to have_link(client.full_name)
    end

    scenario "item created" do
      item.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created an item")
      expect(page).to have_link(item.description.titleize)
    end

    scenario "item updated" do
      item.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated an item")
      expect(page).to have_link(item.description.titleize)
    end

    scenario "job created" do
      job.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created a job")
      expect(page).to have_link(job.name)
    end

    scenario "job updated" do
      job.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated a job")
      expect(page).to have_link(job.name)
    end

    scenario "letter created" do
      letter.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created a letter")
      expect(page).to have_link(letter.humanized_category)
    end

    scenario "letter updated" do
      letter.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated a letter")
      expect(page).to have_link(letter.humanized_category)
    end

    scenario "proposal created" do
      proposal.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created a proposal")
      expect(page).to have_link(proposal.humanized_name)
    end

    scenario "proposal updated" do
      proposal.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated a proposal")
      expect(page).to have_link(proposal.humanized_name)
    end

    scenario "statement created" do
      statement.create_activity(:create, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} created a statement")
      expect(page).to have_link(statement.humanized_name)
    end

    scenario "statement updated" do
      statement.create_activity(:update, owner: user)
      visit dashboard_path

      expect(page).to have_content("#{user.full_name} updated a statement")
      expect(page).to have_link(statement.humanized_name)
    end

  end

end
