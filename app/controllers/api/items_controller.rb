module Api
  class ItemsController < ApplicationController
    include Secured
    include PresenterParamsHelper

    def index
      authenticate_request!
      presenter = ItemsPresenter.new(params)
      presenter_response_headers(presenter)

      render json: presenter.execute.includes(account: :primary_contact).as_json(include: include_params, methods: params[:methods])
    end

  end
end
