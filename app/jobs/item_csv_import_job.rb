class ItemCsvImportJob < ActiveJob::Base
  queue_as :default

  def perform(csv)
    if CsvItemImporter.new.import(csv)
      csv.destroy
    end
  end

end
