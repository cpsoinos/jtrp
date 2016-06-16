class ItemBatchImportJob < ActiveJob::Base
  queue_as :default

  def perform(proposal, archive)
    if ItemImporter.new(proposal).import(archive)
      archive.destroy
    end
  end

end
