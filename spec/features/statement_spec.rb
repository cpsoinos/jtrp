feature "statement" do

  let(:user) { create(:internal_user) }

  let!(:agreement) { create(:agreement, :active, :consign) }
  let!(:items) { create_list(:item, 5, :sold, sale_price_cents: 5000, client_intention: 'consign', proposal: agreement.proposal) }
  let!(:statement) { create(:statement, agreement: agreement) }

  before do
    Timecop.freeze
    day_incrementer = 1
    items.map do |item|
      item.sold_at = day_incrementer.days.ago
      item.save
      day_incrementer += 1
    end
    sign_in user
  end

  after do
    Timecop.return
  end

  scenario "arrives at account's statements list" do
    visit accounts_path
    click_link("View Statements")

    expect(page).to have_content("Statements")
    expect(page).to have_content("for #{agreement.account.full_name}")
    expect(page).to have_content("Unpaid Statements")
    expect(page).to have_content("Paid Statements")
    expect(page).to have_content("Date")
    expect(page).to have_content("Agreement No.")
    expect(page).to have_content(agreement.id)
    expect(page).to have_link(agreement.id)
    expect(page).to have_content("Balance")
    expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(statement.amount_due_to_client))
    expect(page).to have_content("Paid?")
    expect(page).to have_content("unpaid")
  end

end
