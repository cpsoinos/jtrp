class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :find_company, :find_categories, :meta_tags
  before_filter :verify_webhook_auth_header

  def receive
    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    WebhookProcessor.new(data).process
    head :ok
  end

  protected

  def verify_webhook_auth_header
    unless request.headers['X-Clover-Auth Code'] == ENV['CLOVER_WEBHOOK_AUTH_CODE']
      head :bad_request
    end
  end

end
