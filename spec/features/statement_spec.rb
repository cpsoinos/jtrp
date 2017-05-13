feature "statement" do

  let(:user) { create(:internal_user) }

  let(:account) { create(:account, :active, :with_client) }
  let(:proposal) { create(:proposal, :active, job: create(:job, :active, account: account)) }
  let!(:agreement) { create(:agreement, :active, :consign, proposal: proposal) }
  let!(:items) { create_list(:item, 5, :sold, sale_price_cents: 5000, client_intention: 'consign', proposal: agreement.proposal) }
  let!(:statement) { create(:statement, account: account) }

  context "internal user" do

    before do
      Timecop.freeze("October 1, 2016")
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
      visit accounts_path(status: "active")
      click_link("View Statements")

      expect(page).to have_content("Statements")
      expect(page).to have_content("for #{statement.account.full_name}")
      expect(page).to have_content("Unpaid")
      expect(page).to have_content("Paid")
      expect(page).to have_content("Date")
      expect(page).to have_content("September, 2016")
      expect(page).to have_link(account.inverse_full_name)
      expect(page).to have_content("Amount")
      expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(statement.amount_due_to_client))
      expect(page).to have_content("Status")
      expect(page).to have_content("unpaid")
    end

    scenario "arrives at a statement page" do
      visit accounts_path(status: "active")
      click_link("View Statements")
      click_link(statement.humanized_name)

      expect(page).to have_content("Consignment Sales")
      expect(page).to have_content("September, 2016")
      expect(page).to have_content("Account # #{statement.account_id}")
      statement.items.each do |item|
        expect(page).to have_link("Item No. #{item.account_item_number}: #{item.original_description}")
        expect(page).to have_content("Asking Price: #{ActionController::Base.helpers.humanized_money_with_symbol(item.listing_price)}")
        expect(page).to have_content("Min. Price: #{ActionController::Base.helpers.humanized_money_with_symbol(item.minimum_sale_price)}")
        expect(page).to have_content("Consigned at: #{item.consignment_rate}%")
        expect(page).to have_content("Date Sold: #{item.sold_at.strftime('%-m/%-d/%y')}")
        expect(page).to have_content("Date Consigned: #{item.try(:listed_at).try(:strftime, '%-m/%-d/%y')}")
        expect(page).to have_content("Days Consigned: #{item.listed_at.present? ? (item.sold_at.to_date - item.listed_at.to_date).to_i : 'n/a'}")
        expect(page).to have_content("Sale Price: #{ActionController::Base.helpers.humanized_money_with_symbol(item.sale_price)}")
        expect(page).to have_content("Consignment Fee: #{ActionController::Base.helpers.humanized_money_with_symbol((item.sale_price * item.consignment_rate) / 100)}")
        expect(page).to have_content("Due to Consignor: #{ActionController::Base.helpers.humanized_money_with_symbol((item.sale_price - (item.sale_price * (1 - item.consignment_rate))) / 100)}")
      end
      expect(page).to have_content("Total Sales")
      expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(statement.total_sales))
      expect(page).to have_content("Total Fees")
      expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(statement.total_consignment_fee))
      expect(page).to have_content("Due to Consignor")
      expect(page).to have_content(ActionController::Base.helpers.humanized_money_with_symbol(statement.amount_due_to_client))
    end

  end

  context "guest" do

    scenario "tries to arrive at an account's statements list" do
      visit account_statements_path(agreement.account)

      expect(page).to have_content("You must be logged in to access this page!")
    end

    scenario "tries to arrive at a statement page" do
      visit account_statement_path(agreement.account, statement)

      expect(page).to have_content("You must be logged in to access this page!")
    end

  end

  context "unauthorized user" do

    let(:unauthorized_user) { create(:user) }

    before do
      sign_in unauthorized_user
    end

    scenario "tries to arrive at an account's statements list" do
      visit account_statements_path(agreement.account)

      expect(page).to have_content("Sorry, you don't have permission to access this page!")
    end

    scenario "tries to arrive at a statement page" do
      visit account_statement_path(agreement.account, statement)

      expect(page).to have_content("Sorry, you don't have permission to access this page!")
    end

  end

end
