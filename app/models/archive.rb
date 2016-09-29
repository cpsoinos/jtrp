class Archive < ActiveRecord::Base
  audited
  
  mount_uploader :archive, ArchiveUploader

  def save_and_process_items(proposal)
    self.remote_archive_url = has_remote_archive_net_url? ? remote_archive_net_url : archive.direct_fog_url(with_path: true)
    save
    ItemBatchImportJob.perform_later(proposal, self)
  end

end
