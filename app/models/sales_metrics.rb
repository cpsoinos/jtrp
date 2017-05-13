class SalesMetrics

  attr_reader :day

  def initialize(day)
    @day = day
  end

  def daily_sales
    payments.sum(:amount_cents) / 100
  end

  private

  def payments
    @_payments ||= begin
      if day_finished?
        Rails.cache.fetch("daily_sales_#{timeframe}") do
          Payment.where(created_at: timeframe)
        end
      else
        Payment.where(created_at: timeframe)
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
