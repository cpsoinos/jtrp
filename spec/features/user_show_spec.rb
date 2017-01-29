feature "user show" do

  let(:user) { create(:user) }

  scenario "visits show page" do
    sign_in user
    visit user_path(user)

    expect(page).to have_content("My Account")
    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.phone)
    expect(page).to have_content(user.address_1)
    expect(page).to have_content(user.address_2)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_link("Edit")
  end

  scenario "cannot visit another user's profile" do
    user2 = create(:user)
    sign_in user2
    visit user_path(user)

    expect(page).to have_content("You do not have access to this page.")
  end

  scenario "internal user can visit another user's profile" do
    internal_user = create(:internal_user)
    sign_in internal_user
    visit user_path(user)

    expect(page).to have_content("#{user.full_name}'s Account")
  end

end
