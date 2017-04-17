class ClientMetrics

  attr_reader :month

  def initialize(month)
    @month = month
  end

  def daily_clients
    clients.count
  end

  private

  def clients
    @_clients ||= begin
      if month_finished?
        Rails.cache.fetch("monthly_clients_#{timeframe}") do
          Client.where(created_at: timeframe)
        end
      else
        Client.where(created_at: timeframe)
      end
    end
  end

  def timeframe
    @_timeframe ||= month.beginning_of_month..month.end_of_month
  end

  def month_finished?
    month > DateTime.now.end_of_month
  end

end
