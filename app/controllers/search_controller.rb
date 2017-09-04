class SearchController < ApplicationController
  before_action :filter_results_for_guests

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
    opts = params.require(:search).permit(:query, :include_subcategories, :status, :page, :by_category_id).reject{|_, v| v.blank?}
    opts = handle_subcategories(opts)
    opts
  end

  def handle_subcategories(opts)
    return unless params[:search].present?
    if opts.delete(:include_subcategories)
      if opts[:by_category_id].present?
        parent_id = opts[:by_category_id]
        child_ids = Category.where(parent_id: opts[:by_category_id]).pluck(:id)
        ids = child_ids << parent_id
        opts[:by_category_id] = ids
        # params[:search][:by_category_id] += Category.where(parent_id: params[:search][:by_category_id]).pluck(:id) <<
      end
    end
    opts
  end

end
