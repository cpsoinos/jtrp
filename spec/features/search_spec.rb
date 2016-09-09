feature "search" do

  let(:item) { create(:item) }
  let(:user) { create(:internal_user) }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "searches for an existing item", js: true do
      visit root_path
      click_link("search")
      fill_in("query", with: item.description)
      find("#query").native.send_keys(:return)

      expect(page).to have_link("Items")
      expect(page).to have_link(item.description)
    end

    scenario "searches for a non-existing item", js: true do
      visit root_path
      click_link("search")
      fill_in("query", with: "The Jungle Book")
      find("#query").native.send_keys(:return)

      expect(page).to have_content('Sorry, no results found for "The Jungle Book".')
    end

  end



end
