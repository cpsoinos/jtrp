class MetricsPresenter

  def build_json_for_sales
    {
      labels: day_labels,
      series: sales_series
    }.to_json
  end

  def build_json_for_customers
    {
      labels: day_labels,
      series: customer_series
    }.to_json
  end

  def build_json_for_clients
    {
      labels: month_labels,
      series: client_series
    }.to_json
  end

  def build_metrics
    {
      owned_count: Item.owned.count,
      consigned_count: Item.consigned.count,
      potential_count: Item.potential.count,
      thirty_day_revenue: Order.thirty_day_revenue,
      owed_to_consignors: Item.consigned.sold.where("items.sold_at >= ?", 30.days.ago).sum(:sale_price_cents) / 2,
      sales_change: (((this_week_sales - last_week_sales) / this_week_sales) * 100).round(2),
      customers_change: (((this_week_customers - last_week_customers) / this_week_customers) * 100).round(2),
      clients_change: (((this_month_clients - last_month_clients) / this_month_clients) * 100).round(2)
    }
  end

  def day_labels
    @_day_labels ||= [6, 5, 4, 3, 2, 1, 0].map { |d| d.days.ago.in_time_zone('Eastern Time (US & Canada)').strftime("%a") }
  end

  def month_labels
    @_month_labels ||= [5, 4, 3, 2, 1, 0].map { |d| d.months.ago.in_time_zone('Eastern Time (US & Canada)').strftime("%b") }
  end

  def sales_series
    @_sales_series ||= [6, 5, 4, 3, 2, 1, 0].map { |d| SalesMetrics.new(d.days.ago.in_time_zone('Eastern Time (US & Canada)')).daily_sales }
  end

  def customer_series
    @_customer_series ||= [6, 5, 4, 3, 2, 1, 0].map { |d| CustomerMetrics.new(d.days.ago.in_time_zone('Eastern Time (US & Canada)')).daily_customers }
  end

  def client_series
    @_client_series ||= [5, 4, 3, 2, 1, 0].map { |d| ClientMetrics.new(d.months.ago.in_time_zone('Eastern Time (US & Canada)')).daily_clients }
  end

  def last_week_sales
    @_last_week_sales ||= Payment.where(created_at: 2.weeks.ago..1.week.ago).sum(:amount_cents).to_f
  end

  def this_week_sales
    @_this_week_sales ||= Payment.where(created_at: 1.weeks.ago..DateTime.now).sum(:amount_cents).to_f
  end

  def last_week_customers
    @_last_week_customers ||= Customer.where(created_at: 2.weeks.ago..1.week.ago).count.to_f
  end

  def this_week_customers
    @_this_week_customers ||= Customer.where(created_at: 1.weeks.ago..DateTime.now).count.to_f
  end

  def last_month_clients
    @_last_month_clients ||= Client.where(created_at: 2.months.ago..1.month.ago).count.to_f
  end

  def this_month_clients
    @_this_month_clients ||= Client.where(created_at: 1.month.ago..DateTime.now).count.to_f
  end

end
