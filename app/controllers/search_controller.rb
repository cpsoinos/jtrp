class SearchController < ApplicationController
  layout "ecommerce"

  def index
    # @results = begin
    #   if current_user.try(:internal?)
    #     PgSearch.multisearch(params[:query]).map(&:searchable).uniq
    #     @results = @results.compact.group_by { |r| r.class.name.underscore.downcase }
    #   else
    #     PgSearch.multisearch(params[:query]).where(searchable_type: "Item").map(&:searchable).uniq
    #   end
    # end
    # @results = PgSearch.multisearch(params[:query]).where(searchable_type: "Item").map(&:searchable).uniq
    # @results = @results.page(params[:page])
    find_results
  end

  private

  def find_results
    # if !current_user.internal?
      @results = Item.active.includes(:pg_search_document).joins(:pg_search_document).merge(PgSearch.multisearch(params[:query])).page(params[:page])
    # end
  end

end
