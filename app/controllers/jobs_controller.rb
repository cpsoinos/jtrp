class JobsController < ApplicationController
  before_filter :require_internal

  def index
    @account = Account.find(params[:account_id])
    @jobs = @account.jobs.filter(params.slice(:status))
  end

end
