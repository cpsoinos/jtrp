feature "yard sale" do

  let(:user) { create(:internal_user) }
  let(:account) { create(:account, :yard_sale) }
  let(:job) { create(:job, account: account, address_1: "55 Fifty Street", address_2: "Suite 5", city: "Fiftyville", state: "MA", zip: "01234") }
  let(:proposal) { create(:proposal, job: job, created_by: user) }
  let(:agreement) { create(:agreement, proposal: proposal) }
  let(:item) { create(:item, :with_initial_photo, proposal: proposal) }

  before do
    sign_in user
  end

  scenario "wants to add an item from home page" do
    visit root_path

    expect(page).to have_link("Yard Sale")
  end

  scenario "clicks 'Yard Sale' link from home page" do
    visit root_path
    click_link("Yard Sale")

    expect(page).to have_content("Yard Sale")
    expect(page).to have_content("New Job")
    expect(page).to have_field("Address 1")
    expect(page).to have_field("Address 2")
    expect(page).to have_field("City")
    expect(page).to have_field("State")
    expect(page).to have_field("Zip")
  end

  scenario "successfully fills in new job information" do
    visit new_account_job_path(account)
    fill_in("Address 1", with: "55 Fifty Street")
    fill_in("Address 2", with: "Suite 5")
    fill_in("City", with: "Fiftyville")
    fill_in("State", with: "MA")
    fill_in("Zip", with: "01234")
    click_link("Next")

    expect(page).to have_content("Job created!")
    expect(page).to have_content("Yard Sale - 55 Fifty Street, Fiftyville, MA")
  end

  scenario "adds items" do
    visit new_account_job_proposal_path(account, job)

    expect(page).not_to have_content("Proposal")
    expect(page).to have_content("Add an item")
    expect(page).to have_field("Description")
    expect(page).to have_field("Purchase Price")
    expect(page).to have_field("item[initial_photos][]")

    fill_in("Description", with: "Chair")
    fill_in("Purchase Price", with: "55.55")
    attach_file('item[initial_photos][]', File.join(Rails.root, '/spec/fixtures/test.png'))
    click_on("Create Item")

    expect(page).to have_content("Item created")
    expect(page).to have_content("Chair")
    expect(page).to have_css("img[src*='test.png']")

    item = Item.first

    expect(item.description).to eq("Chair")
    expect(item.client_intention).to eq("sell")
    expect(item.purchase_price_cents).to eq(5555)
  end

  scenario "generates 'agreement'" do
    item
    visit edit_account_job_proposal_path(account, job, proposal)
    click_link("Generate Agreements")

    expect(page).to have_content("Purchase Invoice")
    expect(page).to have_field("scanned_agreement")
  end

  scenario "uploads receipt" do
    item
    agreement
    visit account_job_proposal_agreements_path(account, job, proposal)
    attach_file('item[initial_photos][]', File.join(Rails.root, '/spec/fixtures/test.pdf'))
    click_button("Create Scanned Agreement")

    expect(page).to have_css("iframe[src*='test.pdf']")
    expect(item.status).to eq("active")
    expect(agreement.status).to eq("active")
    expect(job.status).to eq("active")
  end

end
