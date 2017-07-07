class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :find_company, :find_categories, :meta_tags
  before_filter :verify_webhook_auth_header

  def receive
    Webhooks::Creator.new(params[:integration_name], data).create
    head :ok
  end

  protected

  def verify_webhook_auth_header
    if params[:integration_name] == 'clover'
      unless request.headers['HTTP_X_CLOVER_AUTH'] == ENV['CLOVER_WEBHOOK_AUTH_CODE']
        head :bad_request
      end
    end
  end

  def data
    if request.headers['Content-Type'] == 'application/json'
      JSON.parse(request.body.read)
    else
      # application/x-www-form-urlencoded
      params.as_json
    end
  end

end
