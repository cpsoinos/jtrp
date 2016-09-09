feature "update an item" do

  let(:item) { create(:item) }
  let(:syncer) { double("syncer") }

  before do
    allow(InventorySync).to receive(:new).and_return(syncer)
    allow(syncer).to receive(:remote_create).and_return(true)
    allow(syncer).to receive(:remote_update).and_return(true)
  end

  context "internal user" do

    let(:user) { create(:internal_user) }

    before do
      sign_in user
    end

    scenario "visits edit item path" do
      visit item_path(item)

      expect(page).to have_field("Description")
      expect(page).to have_field("sale-date")
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
      # expect(page).not_to have_content("Chair")
    end

    # scenario "adds a second initial photo", js: true do
    #   Capybara.ignore_hidden_elements = false
    #   item = create(:item, :with_initial_photo)
    #   visit edit_item_path(item)
    #
    #   expect(page).to have_css("img[src*='test.jpg']")
    #
    #   attach_file("file", File.join(Rails.root, "/spec/fixtures/test_2.png"))
    #   click_button("Update Item")
    #   wait_for_ajax
    #
    #   expect(page).to have_css("img[src*='test.jpg']")
    #   expect(page).to have_css("img[src*='test_2.jpg']")
    #   Capybara.ignore_hidden_elements = true
    # end

    # scenario "adds a second listing photo" do
    #   pending("listing photos")
    #   item = create(:item, :with_listing_photo)
    #   visit edit_item_path(item)
    #
    #   expect(page).to have_css("img[src*='test.jpg']")
    #
    #   attach_file("item_listing_photos", File.join(Rails.root, "/spec/fixtures/test_2.png"))
    #   click_button("Update Item")
    #
    #   expect(page).to have_css("img[src*='test.jpg']")
    #   expect(page).to have_css("img[src*='test_2.jpg']")
    # end

    scenario "deletes an item" do
      visit item_path(item)
      click_link("delete_forever")

      expect(page).to have_content("Item removed")
    end

  end

end
