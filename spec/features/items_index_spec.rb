feature "item index" do

  let(:user) { create(:internal_user) }
  let!(:potential_items) { create_list(:item, 3, description: "Connor") }
  let!(:active_owned_items) { create_list(:item, 3, :active, description: "Buddy") }
  let!(:active_consigned_items) { create_list(:item, 3, :active, description: "Vasha", client_intention: "consign") }
  let!(:sold_items) { create_list(:item, 2, :sold, description: "Katniss") }
  let!(:all_items) { active_owned_items | active_consigned_items | sold_items | potential_items }
  let(:intentions) { ["consigned", "owned", "will donate", "will dump", "undecided"] }

  before do
    sign_in user
  end

  before :each, js: true do
    page.execute_script("$($('a[role=tab]')[0]).tab('show');")
  end

  context "all items" do

    scenario "visits item list from home page" do
      visit root_path
      click_link("All Items")

      expect(page).to have_content("All Items")
    end

    scenario "visits item list" do
      Item.first.update_attribute("client_intention", "sell")
      Item.second.update_attribute("client_intention", "consign")
      Item.third.update_attribute("client_intention", "donate")
      Item.fourth.update_attribute("client_intention", "dump")
      visit items_path

      expect(page).to have_content("All Items")
      intentions.each do |intention|
        next if intention == "undecided"
        expect(page).to have_link(intention)
      end
    end

  end

  context "purchased items" do

    scenario "visits item list" do
      visit items_path(status: 'active', type: 'sell')

      expect(page).to have_content("For Sale items have a signed purchase order and are actively for sale.")
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

    scenario "visits item list from home page" do
      visit root_path
      click_link("Sold")

      expect(page).to have_content("Sold items have been sold.")
    end

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

  context "potential items" do

    scenario "visits item list from home page" do
      visit root_path
      within("#items") do
        click_link("Potential")
      end

      expect(page).to have_content("Potential items have not yet been listed for sale or consigned.")
    end

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
