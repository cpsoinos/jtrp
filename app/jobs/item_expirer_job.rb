class ItemExpirerJob < ActiveJob::Base
  queue_as :cron

  def perform
    expire_items
  end

  private

  def expire_items
    items.each do |item|
      item.mark_expired
    end
  end

  def items
    @_items ||= Item.consigned.where("listed_at < ?", 90.days.ago)
  end

end
