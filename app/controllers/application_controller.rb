class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def find_company
    @company ||= begin
      if params[:company_id]
        Company.find(params[:company_id])
      else
        @category.company
      end
    end
  end

  def find_category
    @category ||= Category.find(params[:category_id])
  end

  def require_internal
    unless current_user.present? && current_user.internal?
      render status: :forbidden, text: "Forbidden fruit"
    end
  end

end
