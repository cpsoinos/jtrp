class SearchController < ApplicationController
  layout "ecommerce"

  def index
    massage_params
    @results = ItemsPresenter.new(params).search.execute
    respond_to do |format|
      format.html
      format.js { render :results }
    end
  end

  private

  def massage_params
    unless current_user.try(:internal?)
      params.merge!(status: "active")
    end

    if params[:by_category_id].present?
      if params[:include_subcategories]
        params[:by_category_id] = [params[:by_category_id]] | Category.where(parent_id: params[:by_category_id]).pluck(:id)
      end
    else
      params.delete(:by_category_id)
    end
  end

  # def find_results
  #   @results = Item.active.includes(:pg_search_document).joins(:pg_search_document).merge(PgSearch.multisearch(params[:query])).page(params[:page])
  #   find_internal_results
  # end

  # def find_internal_results
  #   return unless current_user.try(:internal?)
  # end

end
