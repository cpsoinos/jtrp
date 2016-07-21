require 'csv'
require 'restclient'

class CsvItemImporter

  def import(csv)
    execute(csv)
  end

  private

  def csv_file(csv)
    begin
      url = csv.csv.direct_fog_url(with_path: true)
      response = RestClient::Request.execute({url: url, method: :get, content_type: 'text/csv'})
      csv_file = Tempfile.new("downloaded")
      csv_file.binmode
      csv_file.write(response)
      csv_file
    end

  end

  def execute(csv)
    CSV.foreach(csv_file(csv), headers: true) do |row|
      attrs = row.to_hash.symbolize_keys
      attrs = massage_attrs(attrs)
      account = find_account(attrs)
      proposal = create_proposal(account)
      create_item(proposal)
    end
  end

  def find_account(attrs)
    account = begin
      if attrs[:account] == "jtrp"
        Account.find_or_create_by(company_name: "JTRP", is_company: true)
      else
        find_client(attrs).try(:account)
      end
    end
    if account.nil?
      account = Account.yard_sale
    end
    account
  end

  def find_client(attrs)
    Client.where("last_name ILIKE ?", "%#{attrs[:account]}%").first
  end

  def create_proposal(account)
    account.jobs.last.proposals.create
  end

  def massage_attrs(attrs)
    if attrs[:purchase_price]
      attrs[:purchase_price_cents] = attrs.delete(:purchase_price) * 100
    end
    attrs.delete(:account)
    attrs
  end

  def create_item(proposal, attrs)
    ItemCreator.new(proposal).create(massage_attrs(attrs))
  end

end
