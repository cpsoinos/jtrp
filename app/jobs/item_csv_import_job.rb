class ItemCsvImportJob < ActiveJob::Base
  queue_as :default

  def perform(csv)
    if CsvItemImporter.new(csv).import
      csv.destroy
    end
  end

end
