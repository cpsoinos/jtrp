feature "letter show" do

  let(:user) { create(:internal_user) }

  before do
    sign_in(user)
    Company.jtrp.update_attribute("primary_contact_id", user.id)
  end

  context "expiration pending notice" do
    let(:letter) { create(:letter, note: "This is a personalized note to the client.") }

    it "shows an expiration pending notice message" do
      visit account_letter_path(letter.account, letter)

      expect(page).to have_content("Thank you for consigning your items with us. Your consignment period will soon reach its end. You must retrieve your items by #{letter.pending_deadline} (10 days from the date of this letter), or contact us before then by phone or email for a local delivery quote or to schedule a local delivery. If you do not retrieve your items by #{letter.pending_deadline}, the items will become our property at that time.")
    end

    it "shows a personalized note" do
      visit account_letter_path(letter.account, letter)

      expect(page).to have_content("This is a personalized note to the client.")
    end

  end

  context "expiration notice" do
    let(:letter) { create(:letter, :expiration_notice, note: "This is a personalized note to the client.") }

    it "shows an expiration notice message" do
      visit account_letter_path(letter.account, letter)

      expect(page).to have_content("Thank you for consigning your items with us. Your 90-day consignment period has reached its end, and as you have not retrieved your items, they have have become our property as of #{letter.hard_deadline}.")
    end

    it "shows a personalized note" do
      visit account_letter_path(letter.account, letter)

      expect(page).to have_content("This is a personalized note to the client.")
    end

  end

end
