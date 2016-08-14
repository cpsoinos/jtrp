class SearchController < ApplicationController

  def index
    @results = begin
      if current_user.try(:internal?)
        PgSearch.multisearch(params[:query]).map(&:searchable).uniq
      else
        PgSearch.multisearch(params[:query]).where(searchable_type: "Item").map(&:searchable).uniq
      end
    end
    @results = @results.compact.group_by { |r| r.class.name.underscore.downcase }
  end

end
