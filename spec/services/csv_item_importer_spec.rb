require 'csv'

describe CsvItemImporter do

  let(:csv) { create(:item_spreadsheet) }
  let(:user) { create(:internal_user) }
  let(:importer) { CsvItemImporter.new(csv, user) }

  let!(:account_1) { create(:account, :with_client, primary_contact: create(:client, last_name: "Vasha")) }
  let!(:account_2) { create(:account, :with_client, primary_contact: create(:client, last_name: "Gienah")) }
  let!(:account_3) { create(:account, :company, company_name: "JTRP") }

  let!(:job_1) { create(:job, account: account_1) }
  let!(:job_2) { create(:job, account: account_2) }
  let!(:job_3) { create(:job, account: account_3) }

  before do
    allow(importer).to receive(:csv_file).and_return(File.join(Rails.root, '/spec/fixtures/item_list.csv'))
    allow_any_instance_of(Item).to receive(:sync_inventory)
  end

  it "can be instantiated" do
    expect(importer).to be_an_instance_of(CsvItemImporter)
  end

  it "imports items" do
    expect {
      importer.import
    }.to change {
      Item.count
    }.by(14)
  end

  it "assigns items to the correct accounts" do
    importer.import

    expect(account_1.items.count).to eq(4)
    expect(account_2.items.count).to eq(5)
  end

end
