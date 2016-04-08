class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :find_company

  def find_company
    @company ||= Company.find_by(name: "Just the Right Piece")
  end

  def find_category
    @category ||= Category.find(params[:category_id])
  end

  def find_proposal
    if params[:proposal_id]
      @proposal ||= Proposal.find(params[:proposal_id])
    end
  end

  def find_purchase_order
    if params[:purchase_order_id]
      @purchase_order ||= PurchaseOrder.find(params[:purchase_order_id])
    end
  end

  def find_clients
    @clients ||= User.client.map do |client|
      [client.full_name, client.id]
    end
  end

  def find_categories
    @categories ||= Category.all.map do |category|
      [category.name, category.id]
    end
  end

  def require_internal
    unless current_user.present? && current_user.internal?
      render status: :forbidden, text: "Forbidden fruit"
    end
  end

end
