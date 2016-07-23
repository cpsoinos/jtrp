class ItemCsvImportJob < ActiveJob::Base
  queue_as :default

  def perform(csv, user)
    if CsvItemImporter.new(csv, user).import
      csv.destroy
    end
  end

end
