class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :find_company


  def find_company
    @company ||= Company.find_by(name: "Just the Right Piece")
  end

  def find_resource # change to resource
    @resource ||= begin
      if params[:proposal_id]
        Proposal.find(params[:proposal_id])
      elsif params[:category_id]
        Category.find(params[:category_id])
      end
    end
  end

  def require_internal
    unless current_user.present? && current_user.internal?
      render status: :forbidden, text: "Forbidden fruit"
    end
  end

end
