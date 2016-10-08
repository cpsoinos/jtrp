class ItemExpirerJob < ActiveJob::Base
  queue_as :default

  def perform(items)
    ItemExpirer.new.expire!(items)
  end

end
