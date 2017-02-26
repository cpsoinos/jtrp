require 'active_job/traffic_control'

class ApplyDiscountsJob < ActiveJob::Base
  queue_as :default
  include ActiveJob::TrafficControl::Throttle

  throttle threshold: 1, period: 1.second

  rescue_from(Clover::CloverError) do
    retry_job wait: 5.minutes, queue: :low
  end

  attr_reader :order

  def perform(order)
    @order = order.reload
    execute
  end

  private

  def execute
    order.discounts.map(&:apply)
    order.items.map do |item|
      if item.discounts.present?
        item.discounts.map(&:apply)
      else
        ItemUpdater.new(item).update(sale_price_cents: item.listing_price_cents, sold_at: order.created_at) unless item.sold?
      end
    end
  end

end
