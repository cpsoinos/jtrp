class DailySummaryEmailJob < ActiveJob::Base
  queue_as :cron

  def perform
    TransactionalEmailer.new(nil, nil, 'daily_sales_digest').send(Company.jtrp.primary_contact, order_list)
  end

  private

  def orders
    @_orders ||= Order.where(created_at: DateTime.now.beginning_of_day..DateTime.now)
  end

  def order_list
    StaticRender.render_partial('orders/order_list', nil, orders: orders)
  end

end
