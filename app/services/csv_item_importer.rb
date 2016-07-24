require 'csv'
require 'restclient'

class CsvItemImporter

  attr_reader :csv, :user

  def initialize(csv, user)
    @csv = csv
    @user = user
  end

  def import
    execute
  end

  private

  def csv_file
    begin
      url = csv.csv.direct_fog_url(with_path: true)
      response = RestClient::Request.execute({url: url, method: :get, content_type: 'text/csv'})
      csv_file = Tempfile.new("downloaded")
      csv_file.binmode
      csv_file.write(response)
      csv_file
    end
  end

  def execute
    CSV.foreach(csv_file, headers: true, encoding: 'utf-8') do |row|
      attrs = row.to_hash.symbolize_keys
      attrs = massage_attrs(attrs)
      account = find_account(attrs)
      proposal = create_proposal(account)
      create_item(proposal, attrs)
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
    attrs.delete(:account)
    account
  end

  def find_client(attrs)
    Client.where("last_name ILIKE ?", "%#{attrs[:account]}%").first
  end

  def create_proposal(account)
    proposal = account.jobs.last.proposals.new
    proposal.created_by = user
    proposal.save
    proposal
  end

  def massage_attrs(attrs)
    if attrs[:purchase_price]
      attrs[:purchase_price_cents] = attrs.delete(:purchase_price) * 100
    end
    attrs[:import] = true
    attrs
  end

  def create_item(proposal, attrs)
    ItemCreator.new(proposal).create(massage_attrs(attrs))
  end

end
