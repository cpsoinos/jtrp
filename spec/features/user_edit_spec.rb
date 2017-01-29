feature "user edit" do

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  scenario "visits edit page", :pending do
    visit edit_user_path(user)

    expect(page).to have_content("My Account")
    expect(page).to have_field('first_name')
    expect(page).to have_field('last_name')
    expect(page).to have_field('email')
    expect(page).to have_field('phone')
    expect(page).to have_field('address_1')
    expect(page).to have_field('address_2')
    expect(page).to have_field('city')
    expect(page).to have_field('state')
    expect(page).to have_field('zip')
    expect(page).to have_button("Save")
  end

end
