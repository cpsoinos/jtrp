class SearchController < ApplicationController

  def index
    @results = PgSearch.multisearch(params[:query]).map(&:searchable).uniq
  end

end
