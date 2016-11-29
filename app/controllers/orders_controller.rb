class OrdersController < ApplicationController
  before_filter :require_internal

  def index
    @orders = Order.by_date(3.months.ago..2.months.ago)
  end

  def show

  end


end
