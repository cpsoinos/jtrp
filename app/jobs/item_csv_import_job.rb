class ItemCsvImportJob < ActiveJob::Base
  queue_as :default

  def perform(proposal, csv)
    if CsvItemImporter.new(proposal).import(csv)
      csv.destroy
    end
  end

end
