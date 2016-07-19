feature "home page" do

  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let(:company) { Company.find_by(name: "Just the Right Piece") }

  context "visitor" do

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.slogan)
    end

  end

  context "internal user" do

    let(:user) { create(:internal_user) }
    let!(:item) { create(:item, :active, description: "abc12345", listing_price_cents: nil) }
    let!(:item_2) { create(:item, :active, description: "defghij", listing_price_cents: nil) }
    let(:syncer) { double("syncer") }

    before do
      sign_in user
      allow(InventorySync).to receive(:new).and_return(syncer)
      allow(syncer).to receive(:remote_create).and_return(true)
      allow(syncer).to receive(:remote_update).and_return(true)
    end

    it "has navigation links" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).not_to have_content(company.slogan)

      expect(page).to have_link("Items")
      within("#items") do
        expect(page).to have_link("Potential")
        expect(page).to have_link("Active")
        expect(page).to have_link("Sold")
        expect(page).to have_link("All Items")
      end

      expect(page).to have_link("Accounts")
      within("#accounts") do
        expect(page).to have_link("Potential")
        expect(page).to have_link("Active")
        expect(page).to have_link("Inactive")
        expect(page).to have_link("All Accounts")
      end

      expect(page).to have_link("Jobs")
      within("#jobs") do
        expect(page).to have_link("Potential")
        expect(page).to have_link("Active")
        expect(page).to have_link("Complete")
        expect(page).to have_link("All Jobs")
      end
    end

    it "has information panels" do
      visit root_path

      expect(page).to have_content("Owned Items For Sale")
      expect(page).to have_content("Consigned Items For Sale")
      expect(page).to have_content("Sold in the last 30 days")
    end

    it "has an activity feed" do
      expect(page).to have_content("Activity Feed")
    end

    context "to do list" do
      it "has a to do list" do
        expect(page).to have_content("To Do")
        expect(page).to have_content(item.description)
        expect(page).to have_content("needs a price added")
      end

      scenario "completes a to do list item", js: true do
        first(:button, "done").click
        expect(page).to have_content("SKU: #{item.id}")
        expect(page).to have_field("Listing price")

        fill_in("Listing price", with: "12.34")
        click_button("Update Item")
        wait_for_ajax
        item.reload

        expect(page).not_to have_content(item.description)
        expect(item.listing_price_cents).to eq(1234)
      end

      scenario "closes a to do list modal without completing", js: true do
        first(:button, "done").click
        click_button("Close")
        wait_for_ajax

        expect(page).to have_field("Listing price", visible: false)
        expect(page).to have_content("#{item.description} needs a price added")
      end

      scenario "completes a to do list item and starts a second", js: true do
        first(:button, "done").click
        fill_in("Listing price", with: "12.34")
        click_button("Update Item")
        wait_for_ajax

        first(:button, "done").click
        expect(page).to have_content("SKU: #{item_2.id}")
        expect(page).to have_field("Listing price")
      end
    end

    context "clicks links" do

      context "items" do
        scenario "potential" do
          visit root_path
          within('#items') do
            click_link("Potential")
          end

          expect(page).to have_content("Potential items have not yet been listed for sale or consigned.")
        end

        scenario "active" do
          visit root_path
          within('#items') do
            click_link("Active")
          end

          expect(page).to have_content("Active items are actively for sale or on consignment.")
        end

        scenario "sold" do
          visit root_path
          within('#items') do
            click_link("Sold")
          end

          expect(page).to have_content("Sold items have been sold.")
        end
      end

      context "accounts" do
        scenario "potential" do
          visit root_path
          within('#accounts') do
            click_link("Potential")
          end

          expect(page).to have_content("Potential accounts have not yet signed an agreement.")
        end

        scenario "active" do
          visit root_path
          within('#accounts') do
            click_link("Active")
          end

          expect(page).to have_content("Active accounts have an active job.")
        end

        scenario "inactive" do
          visit root_path
          within('#accounts') do
            click_link("Inactive")
          end

          expect(page).to have_content("Inactive accounts have completed agreements or service orders.")
        end
      end

      context "jobs" do
        scenario "potential" do
          visit root_path
          within('#jobs') do
            click_link("Potential")
          end

          expect(page).to have_content("Showing potential jobs")
        end

        scenario "active" do
          visit root_path
          within('#jobs') do
            click_link("Active")
          end

          expect(page).to have_content("Showing active jobs")
        end

        scenario "inactive" do
          visit root_path
          within('#jobs') do
            click_link("Completed")
          end

          expect(page).to have_content("Showing completed jobs")
        end
      end
    end

  end

end
