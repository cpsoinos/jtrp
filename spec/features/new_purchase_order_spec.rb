feature "new purchase order" do

  context "visitor" do
    scenario "visit root path" do
      visit root_path

      expect(page).not_to have_link("New Purchase Order")
    end
  end

  context "internal user" do
    let(:user) { create(:user, :internal) }
    let!(:client) { create(:user, :client) }

    before do
      sign_in user
    end

    scenario "visit root path" do
      visit root_path

      expect(page).to have_link("New Purchase Order")
    end

    scenario "clicks 'New Purchase Order' link" do
      visit root_path
      click_link("New Purchase Order")

      expect(page).to have_content("Step 1: Select a Client")
    end

    context "existing client" do

      scenario "an existing client" do
        visit new_purchase_order_path

        expect(page).to have_select("purchase_order_client_id", with_options: [client.full_name])
      end

      scenario "selects an existing client" do
        visit new_purchase_order_path
        select(client.full_name, from: "purchase_order_client_id")
        click_button("Next")

        expect(page).to have_content("Add an Item")
        expect(page).to have_field("item_name")
        expect(page).to have_field("item_description")
        expect(page).to have_field("item_initial_photos")
        expect(page).to have_field("item_purchase_price")
        expect(page).to have_field("item_condition")
        expect(page).to have_button("Add Item")
      end

      let(:purchase_order) { create(:purchase_order, client: client)}

      scenario "successfully fills in purchase_order information", js: true do
        visit edit_purchase_order_path(purchase_order)
        fill_in("item_name", with: "Chair")
        fill_in("item_description", with: "sit in it")
        attach_file('item_initial_photos', File.join(Rails.root, '/spec/fixtures/test.png'))
        fill_in("item_purchase_price", with: "45")
        fill_in("item_condition", with: "like new")
        click_on("Add Item")

        expect(page).to have_content("sit in it")
        expect(page).to have_selector("img[src$='test.png']")
        expect(page).to have_content("$45")
      end

      scenario "deletes an item" do
        create(:item, purchase_order: purchase_order)
        visit edit_purchase_order_path(purchase_order)
        click_on("Delete")

        expect(page).to have_content("Item removed")
      end

    end

    context "new client" do

      scenario "successfully creates a new client", js: true do
        visit new_purchase_order_path
        click_on("New Client")

        fill_in("user_email", with: "sally@salamander.com")
        fill_in("user_first_name", with: "Sally")
        fill_in("user_last_name", with: "Salamander")
        fill_in("user_address_1", with: "3 Tropic Schooner")
        fill_in("user_address_2", with: "Pool 1")
        fill_in("user_city", with: "Naples")
        fill_in("user_state", with: "FL")
        fill_in("user_zip", with: "12345")
        click_on("Create Client")

        expect(page).to have_content("Add an Item")
      end

      scenario "unsuccessfully creates a new client", js: true do
        visit new_purchase_order_path
        click_on("New Client")

        fill_in("user_first_name", with: "Sally")
        fill_in("user_last_name", with: "Salamander")
        fill_in("user_address_1", with: "3 Tropic Schooner")
        fill_in("user_address_2", with: "Pool 1")
        fill_in("user_city", with: "Naples")
        fill_in("user_state", with: "FL")
        fill_in("user_zip", with: "12345")
        click_on("Create Client")

        expect(page).to have_content("Email can't be blank")
      end

    end

  end

end
