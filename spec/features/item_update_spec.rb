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
    end

    scenario "deletes an item" do
      visit item_path(item)
      click_link("delete_forever")

      expect(page).to have_content("Item removed")
    end

  end

end
