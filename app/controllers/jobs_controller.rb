class JobsController < ApplicationController
  before_filter :require_internal

  def index
    @jobs = JobsPresenter.new(params).filter
    @filter = params[:status]
    @account = Account.find(params[:account_id]) if params[:account_id]
  end

end
