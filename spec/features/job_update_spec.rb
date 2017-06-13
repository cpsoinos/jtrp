feature "update an item" do

  let(:user) { create(:internal_user) }
  let(:job) { create(:job) }
  let(:account) { job.account }

  context "internal user" do

    before do
      sign_in user
    end

    scenario "visits edit job page" do
      visit account_job_path(account, job)
      within(".btn-group") do
        click_link("edit")
      end

      expect(page).to have_content(job.name)
      expect(page).to have_field("job[address_1]")
      expect(page).to have_field("job[address_2]")
      expect(page).to have_field("job[city]")
      expect(page).to have_field("job[state]")
      expect(page).to have_field("job[zip]")
    end

    scenario "successfully updates a job" do
      visit edit_account_job_path(account, job)

      fill_in("job[address_1]", with: "195 Binney St.")
      fill_in("job[address_2]", with: "Apt. 2313")
      fill_in("job[city]", with: "Cambridge")
      fill_in("job[state]", with: "Massachusetts")
      fill_in("job[zip]", with: "02142")

      click_button("Save")

      expect(page).to have_content("Job updated")
      expect(page).to have_content("195 Binney St.")
    end

    scenario "unsuccessfully updates a job" do
      visit edit_account_job_path(account, job)

      fill_in("job[address_1]", with: "")
      fill_in("job[address_2]", with: "Apt. 2313")
      fill_in("job[city]", with: "Cambridge")
      fill_in("job[state]", with: "Massachusetts")
      fill_in("job[zip]", with: "02142")

      click_button("Save")

      expect(page).to have_content("Job could not be saved")
      expect(page).to have_content("Address 1 can't be blank")
    end

  end

end
