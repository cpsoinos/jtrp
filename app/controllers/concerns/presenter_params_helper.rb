module PresenterParamsHelper
  def presenter_params
    params.slice(:offset, :limit, :sort_column, :sort_direction, :search, :filters, :scope)
  end

  def presenter_response_headers(presenter)
    if presenter_params[:offset] || presenter_params[:limit]
      response.headers["X-total"] = presenter.total_count.to_s
      response.headers["X-offset"] = presenter.offset.to_s
      response.headers["X-limit"] = presenter.per_page.to_s
    end

    if presenter.respond_to?(:filtered_total)
      response.headers["X-filtered-total"] = presenter.filtered_total.to_s
    end
  end

end
