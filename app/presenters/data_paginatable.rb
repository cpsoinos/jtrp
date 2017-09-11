module DataPaginatable

  def per_page
    params[:per_page].nil? ? nil : Integer(params[:per_page])
  end

  def offset
    params[:offset].nil? ? nil : Integer(params[:offset])
  end

  def sort_column
    (sortable_columns & [params[:sort_column]]).first || default_sort
  end

  def sort_direction
    (['asc','desc'] & [params[:sort_direction]]).first
  end

  def paginate
    @rows = rows.offset(offset).limit(per_page) unless params[:no_pagination]
    self
  end

end
