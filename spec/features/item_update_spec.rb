feature "update an item" do

  let(:item) { create(:item) }

  context "internal user" do

    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    scenario "visits edit item path" do
      visit item_path(item)

      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
    end

    scenario "successfully updates an item", js: true do
      visit item_path(item)

      expect(page).to have_content(item.name)

      bip_text(item, :name, "Chair")
      bip_text(item, :description, "Sit in it")
      bip_text(item, :height, "3'")
      bip_text(item, :width, "1'")
      bip_text(item, :depth, "1 1/2'")

      expect(page).to have_content("Chair")
      expect(page).to have_content("Sit in it")
      expect(page).to have_content("3'")
      expect(page).to have_content("1'")
      expect(page).to have_content("1 1/2'")
    end

    scenario "unsuccessfully updates an item", js: true do
      visit item_path(item)

      expect(page).to have_content(item.name)

      bip_text(item, :name, "")

      expect(page).not_to have_content("Chair")
      expect(page).to have_content(item.name)
    end

    scenario "adds a second initial photo" do
      item = create(:item, :with_initial_photo)
      visit item_path(item)

      expect(page).to have_css("img[src*='test.png']")

      attach_file("item_initial_photos", File.join(Rails.root, "/spec/fixtures/test_2.png"))
      click_button("Update Item")

      expect(page).to have_css("img[src*='test.png']")
      expect(page).to have_css("img[src*='test_2.png']")
    end

    scenario "adds a second listing photo" do
      item = create(:item, :with_listing_photo)
      visit item_path(item)

      expect(page).to have_css("img[src*='test.png']")

      attach_file("item_listing_photos", File.join(Rails.root, "/spec/fixtures/test_2.png"))
      click_button("Update Item")

      expect(page).to have_css("img[src*='test.png']")
      expect(page).to have_css("img[src*='test_2.png']")
    end

    scenario "deletes an item" do
      visit item_path(item)
      click_link("Delete")

      expect(page).to have_content("Item removed")
    end

  end

end
