feature "update an item" do

  let(:item) { create(:item) }

  context "internal user" do

    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    scenario "visits edit item path" do
      visit item_path(item)

      expect(page).to have_content(item.description)
      expect(page).to have_content(item.description)
    end

    scenario "successfully updates an item" do
      visit item_path(item)
      click_link("edit")

      fill_in("Description", with: "Chair")

      click_button("Update Item")

      expect(page).to have_content("Item was successfully updated.")
      expect(page).to have_content("Chair")
    end

    scenario "unsuccessfully updates an item" do
      visit edit_item_path(item)

      fill_in("Description", with: "")
      click_button("Update Item")

      expect(page).to have_content("Could not update item.")
      expect(page).to have_content("Description can't be blank")
      expect(page).not_to have_content("Chair")
    end

    scenario "adds a second initial photo" do
      item = create(:item, :with_initial_photo)
      visit edit_item_path(item)

      expect(page).to have_css("img[src*='test.png']")

      attach_file("item_initial_photos", File.join(Rails.root, "/spec/fixtures/test_2.png"))
      click_button("Update Item")

      expect(page).to have_css("img[src*='test.png']")
      expect(page).to have_css("img[src*='test_2.png']")
    end

    scenario "adds a second listing photo" do
      item = create(:item, :with_listing_photo)
      visit edit_item_path(item)

      expect(page).to have_css("img[src*='test.png']")

      attach_file("item_listing_photos", File.join(Rails.root, "/spec/fixtures/test_2.png"))
      click_button("Update Item")

      expect(page).to have_css("img[src*='test.png']")
      expect(page).to have_css("img[src*='test_2.png']")
    end

    scenario "deletes an item" do
      visit item_path(item)
      click_link("delete_forever")

      expect(page).to have_content("Item removed")
    end

  end

end
