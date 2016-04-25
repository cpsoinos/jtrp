feature "item tag" do

  let(:user) { create(:user, :internal) }
  let(:item) { create(:item, :with_listing_photo, listing_price: 55) }
  let!(:company) { create(:company, name: "Just the Right Piece") }

  before do
    sign_in user
  end

  scenario "visits item show page" do
    visit item_path(item)

    expect(page).to have_link("Print Tag")
  end

  scenario "clicks on 'Print Tag' link" do
    visit item_path(item)
    click_link("Print Tag")
    convert_pdf_to_page

    expect(page).to have_content("$55.00")
    expect(page).to have_content(item.description)
    expect(page).to have_content(item.token)
  end

end
