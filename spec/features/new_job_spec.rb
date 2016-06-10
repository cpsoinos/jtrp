feature "new job" do

  let(:user) { create(:internal_user) }
  let(:account) { create(:account) }

  before do
    sign_in user
  end

  scenario "clicks 'new job' from the dashboard" do
    visit root_path
    click_link("New Job")

    expect(page).to have
  end

end
