describe "update an item", :skip do

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
      expect(page).to have_field("sold_at")
    end

    scenario "successfully updates an item" do
      visit item_path(item)
      within(".btn-group") do
        click_link("edit")
      end

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

    scenario "sets acquired_at" do
      visit edit_item_path(item)
      fill_in("acquired at", with: "05/16/2016")
      click_button("Update Item")
      item.reload

      expect(item.acquired_at).to eq(DateTime.parse("May 16 2016"))
    end

    scenario "sets acquired_at when sold_at is already set" do
      item = create(:item, :sold)
      visit edit_item_path(item)
      fill_in("acquired at", with: "05/16/2016")
      click_button("Update Item")
      item.reload

      expect(item.acquired_at).to eq(DateTime.parse("May 16 2016"))
      expect(item.acquired_at).not_to eq(item.sold_at)
    end

  end

end
