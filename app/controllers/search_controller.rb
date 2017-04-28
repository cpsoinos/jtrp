class SearchController < ApplicationController
  before_filter :filter_results_for_guests
  before_filter :handle_subcategories
  layout "ecommerce"

  def index
    if params[:search]
      @results = ItemsPresenter.new(search_params.merge(page: params[:page])).execute
    else
      @results = []
    end
    respond_to do |format|
      format.html
      format.js { render :results }
    end
  end

  private

  def filter_results_for_guests
    return unless params[:search].present?
    unless current_user.try(:internal?)
      params[:search][:status] = "active"
    end
  end

  protected

  def search_params
    params.require(:search).permit(:query, :by_category_id, :include_subcategories, :status, :page).reject{|_, v| v.blank?}
  end

  def handle_subcategories
    return unless params[:search].present?
    if params[:search].delete(:include_subcategories)
      if params[:search][:by_category_id].present?
        parent_id = params[:search][:by_category_id]
        child_ids = Category.where(parent_id: params[:search][:by_category_id]).pluck(:id)
        ids = child_ids << parent_id
        params[:search][:by_category_id] = ids
        # params[:search][:by_category_id] += Category.where(parent_id: params[:search][:by_category_id]).pluck(:id) <<
      end
    end
  end

end
