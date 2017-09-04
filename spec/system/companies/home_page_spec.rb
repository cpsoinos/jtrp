describe "home page" do
  include CarrierWaveDirect::Test::CapybaraHelpers

  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let(:company) { Company.find_by(name: "Just the Right Piece") }

  context "visitor" do

    scenario "visits home page" do
      visit root_path

      expect(page).to have_content(company.name)
      expect(page).to have_content("Information")
      expect(page).to have_content("Customer Service")
      expect(page).to have_content("Follow Us")
    end

    scenario "hours of operation" do
      visit root_path

      expect(page).to have_content("Hours of Operation")
      %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday).each do |day|
        expect(page).to have_content("#{day}")
      end
    end

    scenario "address" do
      visit root_path

      expect(page).to have_content(company.address_1)
      expect(page).to have_content(company.city)
      expect(page).to have_content(company.state)
      expect(page).to have_content(company.zip)
      expect(page).to have_content(company.phone)
      expect(page).to have_content(company.website)
    end

    scenario "categories" do
      visit root_path

      Category.primary.categorized.each do |category|
        expect(page).to have_link(category.name)
      end
    end

    scenario "clicks through to a category" do
      visit root_path
      within(".categories-section") do
        click_link(category_1.name)
      end

      expect(page).to have_content(category_1.name)
    end

  end

  context "internal user" do

    scenario "clicks through to a category" do
      visit landing_page_path
      within(".categories-section") do
        click_link(category_1.name)
      end

      expect(page).to have_content(category_1.name)
    end

  end

end
