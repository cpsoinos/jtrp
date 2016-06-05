feature "proposal response" do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let!(:items) { create_list(:item, 6, proposal: proposal) }
  let!(:intentions) { %w(sell consign donate dump move nothing) }

  context "guest" do
    scenario "visits consignment agreement path" do
      visit proposal_response_form_path(proposal)

      expect(page).to have_content("Forbidden")
    end
  end

  context "internal user" do

    before do
      sign_in(user)
      visit proposal_response_form_path(proposal)
    end

    scenario "user chooses client intentions", js: true do
      items.each_with_index do |item, i|
        choose("item_#{item.id}_client_intention_#{intentions[i]}")
        wait_for_ajax
        item.reload
        expect(item.client_intention).to eq(intentions[i])
      end
    end

    context "creates client agreements" do

      scenario "one intention" do
        Item.update_all(client_intention: "sell")
        click_link("Generate Agreements")

        expect(page).to have_link("sell")
      end

      scenario "multiple intentions" do
        items.each_with_index do |item, i|
          item.update_attribute("client_intention", intentions[i])
        end
        click_link("Generate Agreements")

        intentions.each do |intention|
          expect(page).to have_link(intention) unless intention == "nothing"
        end
      end

    end

  end

end
