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
      expect(page).to have_content(company.slogan)
    end

    scenario "clicks through to a category" do
      visit root_path
      within(".categories-row") do
        click_link(category_1.name)
      end

      expect(page).to have_content(category_1.name)
      expect(page).not_to have_link("edit")
      expect(page).not_to have_link("delete_forever")
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

      expect(page).to have_link("Jobs")
    end

    it "has information panels" do
      visit root_path

      expect(page).to have_content("Owned Items For Sale")
      expect(page).to have_content("Consigned Items For Sale")
      expect(page).to have_content("Sold in the last 30 days")
    end

    context "to do list" do

      it "has a to do list" do
        visit root_path
        expect(page).to have_content("To Do")
        expect(page).to have_content(item.description)
        expect(page).to have_content("needs a price added")
      end

      scenario "completes a to do list item", js: true do
        visit root_path
        expect(page).to have_content("needs a price added")
        first(:button, "done").click
        expect(page).to have_content("SKU: #{item.id}")
        expect(page).to have_field("Listing price")

        fill_in("Listing price", with: "12.34")
        click_button("Update Item")
        wait_for_ajax
        item.reload

        expect(page).to have_content("#{item.description} updated!")
        expect(page).not_to have_content("needs a price added")
        expect(item.listing_price_cents).to eq(1234)
      end

      scenario "closes a to do list modal without completing", js: true do
        visit root_path
        first(:button, "done").click
        click_button("×")
        wait_for_ajax

        expect(page).to have_field("Listing price", visible: false)
        expect(page).to have_content("#{item.description} needs a price added")
      end

    end

    context "clicks items links" do

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

    context "home page" do
      scenario "clicks through to a category" do
        visit landing_page_path
        within(".categories-row") do
          click_link(category_1.name)
        end

        expect(page).to have_content(category_1.name)
        expect(page).to have_link("edit")
        expect(page).to have_link("delete_forever")
      end
    end

  end

end
