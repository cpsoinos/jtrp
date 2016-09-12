ActiveRecord::Userstamp.configure do |config|
  config.default_stamper = 'User'
  config.creator_attribute = :created_by_id
  config.updater_attribute = :updated_by_id
  config.deleter_attribute = :deleted_by_id
end
