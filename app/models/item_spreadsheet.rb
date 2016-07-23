class ItemSpreadsheet < ActiveRecord::Base
  mount_uploader :csv, CsvUploader

  def save_and_process_items(user)
    self.remote_csv_url = has_remote_csv_net_url? ? remote_csv_net_url : csv.direct_fog_url(with_path: true)
    save
    ItemCsvImportJob.perform_later(self, user)
  end

end
