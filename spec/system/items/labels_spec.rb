describe "item labels" do

  let(:user) { create(:internal_user) }
  let(:proposal) { create(:proposal) }
  let!(:items) { create_list(:item, 8, listing_price: 55, proposal: proposal) }

  context "internal user" do

    before do
      sign_in user
      allow_any_instance_of(LabelGenerator).to receive(:logo).and_return("#{Rails.root.join('spec', 'fixtures', 'test.png')}")
    end

    scenario "clicks on 'Print Labels' link" do
      visit items_path
      click_link("Print Labels")
      convert_pdf_to_page

      items.each do |item|
        expect(page).to have_content("$55.00")
        expect(page).to have_content(item.description)
        expect(page).to have_content("SKU:")
        expect(page).to have_content("Item No.:")
        expect(page).to have_content("JTRP No.:")
      end
    end

  end

end
