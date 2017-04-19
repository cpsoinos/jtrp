feature "item index" do

  let(:user) { create(:internal_user) }
  let!(:potential_items) { create_list(:item, 3, description: "Connor") }
  let!(:active_owned_items) { create_list(:item, 3, :active, description: "Buddy") }
  let!(:active_consigned_items) { create_list(:item, 3, :active, description: "Vasha", client_intention: "consign") }
  let!(:sold_items) { create_list(:item, 2, :sold, description: "Katniss") }
  let!(:inactive_items) { create_list(:item, 4, :inactive) }
  let!(:all_items) { active_owned_items | active_consigned_items | sold_items | potential_items }
  let(:intentions) { ["consigned", "owned", "undecided"] }

  before do
    sign_in user
  end

  context "all items" do

    scenario "visits item list" do
      Item.first.update_attribute("client_intention", "sell")
      Item.second.update_attribute("client_intention", "consign")
      visit items_path

      expect(page).to have_link("Print Labels")
      intentions.each do |intention|
        next if intention == "undecided"
        expect(page).to have_link(intention)
      end
    end

    scenario "general headers and values" do
      visit items_path

      expect(page).to have_content("Account Item No.")
      expect(page).to have_content("JTRP No.")
      expect(page).to have_content("Consignment Rate")
      expect(page).to have_content("Listing Price")
      expect(page).to have_content("Min. Sale Price")
      expect(page).to have_content("Sale Date")
      expect(page).to have_content("Sale Price")

      Item.all.each do |item|
        expect(page).to have_content(item.id)
        expect(page).to have_content(item.account_item_number)
        expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(item.listing_price))
        expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(item.minimum_sale_price))
      end
    end

  end

  context "purchased items" do

    scenario "visits item list" do
      visit items_path(status: 'active', type: 'sell')

      expect(page).to have_content("For Sale items have a signed purchase invoice and are actively for sale.")
      active_owned_items.each do |item|
        expect(page).to have_link("Buddy")
      end
      expect(page).not_to have_link("Vasha")
      expect(page).not_to have_link("Connor")
      expect(page).not_to have_link("Katniss")
    end

  end

  context "consigned items" do

    scenario "visits item list" do
      visit items_path(status: 'active', type: 'consign')

      expect(page).to have_content("Consigned items have a signed agreement and are actively on consignment.")
      active_owned_items.each do |item|
        expect(page).to have_link("Vasha")
      end
      expect(page).not_to have_link("Buddy")
      expect(page).not_to have_link("Connor")
      expect(page).not_to have_link("Katniss")
    end

  end

  context "sold items" do

    scenario "visits item list" do
      visit items_path(status: 'sold')

      expect(page).to have_content("Sold items have been sold.")
      sold_items.each do |item|
        expect(page).to have_link("Katniss")
      end
      expect(page).not_to have_link("Vasha")
      expect(page).not_to have_link("Buddy")
      expect(page).not_to have_link("Connor")
    end

  end

  context "inactive items" do

    scenario "visits item list" do
      visit items_path(status: 'inactive')

      expect(page).to have_content("Inactive items have been deactivated.")
      inactive_items.each do |item|
        expect(page).to have_link(item.description.titleize)
      end
      expect(page).not_to have_link("Vasha")
      expect(page).not_to have_link("Katniss")
      expect(page).not_to have_link("Buddy")
      expect(page).not_to have_link("Connor")
    end

  end

  context "potential items" do

    scenario "visits item list" do
      visit items_path(status: 'potential')

      expect(page).to have_content("Potential items have not yet been listed for sale or consigned.")
      potential_items.each do |item|
        expect(page).to have_link("Connor")
      end
      expect(page).not_to have_link("Vasha")
      expect(page).not_to have_link("Buddy")
      expect(page).not_to have_link("Katniss")
    end

  end

end
