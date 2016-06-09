class JobsController < ApplicationController
  before_filter :require_internal

  def index
    @jobs = JobsPresenter.new(params).filter
    @filter = params[:status]
    @account = Account.find(params[:account_id]) if params[:account_id]
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @account = Account.find(params[:account_id]) if params[:account_id]
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "Job created"
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
