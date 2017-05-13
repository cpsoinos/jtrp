class CustomerMetrics

  attr_reader :day

  def initialize(day)
    @day = day
  end

  def daily_customers
    customers.count
  end

  private

  def customers
    @_customers ||= begin
      if day_finished?
        Rails.cache.fetch("daily_customers_#{timeframe}") do
          Customer.where(created_at: timeframe)
        end
      else
        Customer.where(created_at: timeframe)
      end
    end
  end

  def timeframe
    @_timeframe ||= day.beginning_of_day..day.end_of_day
  end

  def day_finished?
    day > DateTime.now.end_of_day
  end

end
