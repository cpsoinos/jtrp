class ItemBatchImportJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(proposal, archive)
    if ItemImporter.new(proposal).import(archive)
      archive.destroy
    end
  end

end
