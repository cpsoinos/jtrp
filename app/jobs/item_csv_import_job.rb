class ItemCsvImportJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(csv, user)
    if CsvItemImporter.new(csv, user).import
      csv.destroy
    end
  end

end
