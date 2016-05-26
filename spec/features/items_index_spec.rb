feature "item index" do

  let(:user) { create(:internal_user) }
  let!(:potential_items) { create_list(:item, 3, description: "connor") }
  let!(:active_items) { create_list(:item, 3, :active, description: "buddy") }
  let!(:sold_items) { create_list(:item, 2, :sold, description: "katniss") }
  let!(:all_items) { active_items | sold_items | potential_items }
  let(:intentions) { ["consigned", "owned", "will donate", "will dump", "will move", "undecided"] }

  before do
    sign_in user
  end

  before :each, js: true do
    page.execute_script("$($('a[role=tab]')[0]).tab('show');")
  end

  context "all items" do

    scenario "visits item list from home page", js: true do
      visit root_path
      click_link("Items")
      click_link("All Items")

      expect(page).to have_content("All Items")
    end

    scenario "visits item list" do
      Item.first.update_attribute("client_intention", "sell")
      Item.second.update_attribute("client_intention", "consign")
      Item.third.update_attribute("client_intention", "donate")
      Item.fourth.update_attribute("client_intention", "dump")
      Item.fifth.update_attribute("client_intention", "move")
      visit items_path

      expect(page).to have_content("All Items")
      intentions.each do |intention|
        next if intention
        expect(page).to have_link(intention)
      end
    end

  end

  context "active items" do

    scenario "visits item list from home page", js: true do
      visit root_path
      click_link("Items")
      click_link("Active")

      expect(page).to have_content("Active Items")
    end

    scenario "visits item list" do
      visit items_path(state: 'active')

      expect(page).to have_content("Active Items")
      active_items.each do |item|
        expect(page).to have_link("buddy")
      end
      expect(page).not_to have_link("connor")
      expect(page).not_to have_link("katniss")
    end

  end

  context "sold items" do

    scenario "visits item list from home page", js: true do
      visit root_path
      click_link("Items")
      click_link("Sold")

      expect(page).to have_content("Sold Items")
    end

    scenario "visits item list" do
      visit items_path(state: 'sold')

      expect(page).to have_content("Sold Items")
      sold_items.each do |item|
        expect(page).to have_link("katniss")
      end
      expect(page).not_to have_link("buddy")
      expect(page).not_to have_link("connor")
    end

  end

  context "potential items" do

    scenario "visits item list from home page", js: true do
      visit root_path
      click_link("Items")
      click_link("Potential")

      expect(page).to have_content("Potential Items")
    end

    scenario "visits item list" do
      visit items_path(state: 'potential')

      expect(page).to have_content("Potential Items")
      potential_items.each do |item|
        expect(page).to have_link("connor")
      end
      expect(page).not_to have_link("buddy")
      expect(page).not_to have_link("katniss")
    end

  end

end
