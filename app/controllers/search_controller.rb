class SearchController < ApplicationController
  layout "ecommerce"

  def index
    @results = ItemsPresenter.new(filters: search_params).search.page(params[:page])
    respond_to do |format|
      format.html
      format.js { render :results }
    end
  end

  private

  def search_params
    search_params = params.except(:utf8, :commit, :controller, :index, :action)
    unless current_user.try(:internal?)
      search_params.merge!(status: "active")
    end

    if search_params[:by_category_id].present?
      if search_params[:include_subcategories]
        search_params[:by_category_id] = [search_params[:by_category_id]] | Category.where(parent_id: search_params[:by_category_id]).pluck(:id)
      end
    else
      search_params.delete(:by_category_id)
    end
    search_params
  end

end
