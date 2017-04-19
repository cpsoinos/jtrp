feature "home page" do
  include CarrierWaveDirect::Test::CapybaraHelpers

  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let(:company) { Company.find_by(name: "Just the Right Piece") }

  context "visitor" do

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content("Information")
      expect(page).to have_content("Customer Service")
      expect(page).to have_content("Follow Us")
    end

    scenario "hours of operation" do
      visit root_path

      expect(page).to have_content("Hours of Operation")
      %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday).each do |day|
        expect(page).to have_content("#{day}")
      end
    end

    scenario "address" do
      visit root_path

      expect(page).to have_content(company.address_1)
      expect(page).to have_content(company.city)
      expect(page).to have_content(company.state)
      expect(page).to have_content(company.zip)
      expect(page).to have_content(company.phone)
      expect(page).to have_content(company.website)
    end

    scenario "categories" do
      visit root_path

      Category.primary.categorized.each do |category|
        expect(page).to have_link(category.name)
      end
    end

    scenario "clicks through to a category" do
      visit root_path
      within(".col-md-9") do
        click_link(category_1.name)
      end

      within(".cat_header") do
        expect(page).to have_content(category_1.name)
      end
    end

  end

  context "internal user" do

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

      expect(page).to have_content(company.name)

      expect(page).to have_link("Items")
      expect(page).to have_link("Accounts")
      expect(page).to have_link("Jobs")
    end

    it "has information panels" do
      visit dashboard_path

      expect(page).to have_content("Daily Sales")
      expect(page).to have_content("Daily Customers")
      expect(page).to have_content("Monthly Clients")
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
        sleep(1)

        expect(page).to have_content("#{item.description} updated!")
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
          sleep(1)

          expect(page).to have_content("Email and letter queued for delivery")
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
          sleep(1)

          expect(page).to have_content("Email and letter queued for delivery")
          expect(page).to have_content("Success!")
          expect(page).not_to have_content("#{agreement.account.full_name} needs to be notified that their consignment period is ending soon")
        end

        scenario "does not choose a category", js: true, skip: true do
          Capybara.using_driver(:selenium) do
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

    context "home page" do
      scenario "clicks through to a category" do
        visit landing_page_path
        within(".col-md-9") do
          click_link(category_1.name)
        end

        within(".cat_header") do
          expect(page).to have_content(category_1.name)
        end
      end
    end

  end

end
