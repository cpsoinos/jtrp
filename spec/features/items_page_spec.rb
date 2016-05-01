feature "item pages" do

  let(:user) { create(:internal_user) }
  let!(:potential_items) { create_list(:item, 3) }
  let!(:active_items) { create_list(:item, 3, :active) }
  let!(:sold_items) { create_list(:item, 2, :sold) }
  let!(:all_items) { active_items | sold_items | potential_items }

  before do
    sign_in user
  end

  context "all items" do

    scenario "visits item list from home page", js: true do
      visit root_path
      click_link("Items")
      click_link("All Items")

      expect(page).to have_content("All Items")
    end

    scenario "visits item list" do
      visit items_path

      expect(page).to have_content("All Items")
      all_items.each do |item|
        expect(page).to have_link(item.name)
      end
      expect(page).to have_content("Client:")
      expect(page).to have_content("Purchase price:")
      expect(page).to have_content("Minimum sale price:")
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
        expect(page).to have_link(item.name)
        expect(page).to have_link(item.proposal.client.full_name)
      end
      expect(page).to have_content("Client:")
      expect(page).to have_content("Purchase price:")
      expect(page).to have_content("Minimum sale price:")
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
        expect(page).to have_link(item.name)
      end
      expect(page).to have_content("Client:")
      expect(page).to have_content("Purchase price:")
      expect(page).to have_content("Minimum sale price:")
      expect(page).to have_content("Sale price:")
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
        expect(page).to have_link(item.name)
      end
      expect(page).to have_content("Client:")
      expect(page).to have_content("Purchase price:")
      expect(page).to have_content("Minimum sale price:")
    end

  end

end
