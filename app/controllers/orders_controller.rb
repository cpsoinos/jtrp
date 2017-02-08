class OrdersController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        @orders = Order.includes(:items, :employee, :customer)
        render json: @orders.to_json(include: [:items, :employee, :customer])
      end
    end
  end

end
