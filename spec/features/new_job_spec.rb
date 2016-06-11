feature "new job" do

  let(:user) { create(:internal_user) }
  let(:account) { create(:account) }

  before do
    sign_in user
  end

  scenario "clicks 'new job' from the dashboard" do
    pending("job from dashboard")
    visit root_path
    click_link("New Job")

    expect(page).to have_content("New Job")
    expect(page).to have_field("Address 1")
    expect(page).to have_field("Address 2")
    expect(page).to have_field("City")
    expect(page).to have_field("State")
    expect(page).to have_field("Zip")
  end

end
