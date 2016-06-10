class JobsController < ApplicationController
  before_filter :require_internal
  before_filter :find_accounts, only: :new

  def index
    @jobs = JobsPresenter.new(params).filter
    @filter = params[:status]
    @account = Account.find(params[:account_id]) if params[:account_id]
  end

  def show
    @job = Job.find(params[:id])
    @account = @job.account
  end

  def new
    @account = Account.find(params[:account_id]) if params[:account_id]
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "Job created"
      redirect_to account_job_path(@job.account, @job)
    else
      flash[:warning] = "Job could not be saved"
      redirect_to :back
    end
  end

  protected

  def job_params
    params.require(:job).permit(:account_id, :address_1, :address_2, :city, :state, :zip)
  end

end
