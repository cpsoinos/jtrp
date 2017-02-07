class OrdersController < ApplicationController

  def index
    @orders = Order.includes(:items).page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: @orders.to_json(include: :items) }
    end
  end

end
