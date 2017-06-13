feature "search" do

  let(:item) { create(:item, :active) }
  let(:user) { create(:internal_user) }

  context "guest" do

    scenario "searches for an existing item" do
      visit root_path
      fill_in("search[query]", with: item.description)
      click_on("search")

      expect(page).to have_link(item.description)
    end

    scenario "searches for a non-existing item" do
      visit root_path
      fill_in("search[query]", with: "The Jungle Book")
      click_on("search")

      expect(page).to have_content('No results found')
    end

    scenario "initiates a second search from results page" do
      second_item = create(:item, :active)
      visit root_path
      fill_in("search[query]", with: item.description)
      click_on("search")

      expect(page).to have_link(item.description)

      within("#search-form") do
        fill_in("search[query]", with: second_item.description)
        click_button("Search")
      end

      expect(page).not_to have_link(item.description)
      expect(page).to have_link(second_item.description)
    end

    scenario "successful search by category", js: true do
      category = Category.find_by(name: "Dining Room")
      table = create(:item, :active, description: "Ornamental Table From Overseas", category: category)

      visit search_index_path
      within("#search-form") do
        fill_in("search[query]", with: "table")
        select("Dining Room", from: "search[by_category_id]", visible: false)
        click_button("Search")
      end

      expect(page).to have_link(table.description, wait: 5)
    end

    scenario "unsuccessful search by category", js: true do
      category = Category.find_by(name: "Dining Room")
      table = create(:item, :active, description: "Ornamental Table From Overseas", category: category)

      visit search_index_path
      within("#search-form") do
        fill_in("search[query]", with: "table")
        select("Living Room", from: "search[by_category_id]", visible: false)
        click_button("Search")
      end

      expect(page).not_to have_link(table.description)
    end

    scenario "successful search by category incl. subcategories", js: true do
      category = Category.find_by(name: "Dining Room")
      subcategory = create(:category, name: "Dining Room Tables", parent: category)
      table = create(:item, :active, description: "Ornamental Table From Overseas", category: subcategory)

      visit search_index_path
      within("#search-form") do
        fill_in("search[query]", with: "table")
        select("Dining Room", from: "search[by_category_id]", visible: false)
        click_button("Search")
      end

      expect(page).to have_link(table.description)
    end

    scenario "unsuccessful search by category incl. subcategories", js: true do
      category = Category.find_by(name: "Dining Room")
      subcategory = create(:category, name: "Tables", parent: category)
      table = create(:item, :active, description: "Ornamental Table From Overseas", category: subcategory)

      visit search_index_path
      within("#search-form") do
        fill_in("search[query]", with: "table")
        select("Dining Room", from: "search[by_category_id]", visible: false)
        page.find(".checkbox-material").click
        click_button("Search")
      end

      expect(page).not_to have_link(table.description)
      expect(page).to have_content('No results found')
    end

    scenario "views second page of search results", js: true do
      items = create_list(:item, 26, :active)
      items.each do |item|
        item.update_attributes(description: "blue #{item.id}")
      end
      last_item = items.pop

      Capybara.using_driver(:chrome) do
        visit search_index_path
        within("#search-form") do
          fill_in("search[query]", with: "blue")
          click_button("Search")
        end

        items.each do |item|
          expect(page).to have_link("Blue #{item.id}")
        end

        click_link("Next")

        expect(page).to have_link("Blue #{last_item.id}")
      end
    end

  end

  context "internal user" do

    before do
      sign_in user
    end

    scenario "searches for an existing item" do
      visit dashboard_path
      fill_in("search[query]", with: item.description)
      click_on("search")

      expect(page).to have_link("Items")
      expect(page).to have_link(item.description)
    end

    scenario "searches for a non-existing item" do
      visit dashboard_path
      fill_in("search[query]", with: "The Jungle Book")
      click_on("search")

      expect(page).to have_content('No results found')
    end

    scenario "initiates a second search from results page" do
      second_item = create(:item, :active)
      visit dashboard_path
      fill_in("search[query]", with: item.description)
      click_on("search")

      expect(page).to have_link(item.description)

      within("#search-form") do
        fill_in("search[query]", with: second_item.description)
        click_button("Search")
      end

      expect(page).to have_link(second_item.description)
      expect(page).not_to have_link(item.description)
    end

  end

end
