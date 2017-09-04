class JobsController < ApplicationController
  before_action :require_internal
  before_action :find_accounts, only: :new
  before_action :find_account, only: [:create, :edit, :update]

  def index
    @title = "Jobs"
    @filter = params[:status]
    if params[:account_id]
      @account = Account.find(params[:account_id])
      params[:account_id] = @account.id # to replace slug with id for Filterable
    end
    @jobs = JobsPresenter.new(params).filter
  end

  def show
    @job = Job.includes(:proposals, :agreements).find(params[:id])
    @account = @job.account
    @proposals = @job.proposals
    @agreements = @job.agreements
    @type = params[:type]
    @items = @job.items.includes(:account).filter(filter_params).page(params[:page])
    @title = @job.name
  end

  def new
    @account = Account.find(params[:account_id]) if params[:account_id]
    @job = Job.new
    unless @account.present?
      gon.accounts = build_json_for_accounts
    end
    @title = "#{@account.short_name} - New Job"
  end

  def create
    @job = @account.jobs.new(job_params)
    if @job.save
      @job.create_activity(:create, owner: current_user)
      flash[:notice] = "Job created"
      redirect_to account_job_path(@job.account, @job)
    else
      flash[:alert] = "Job could not be saved"
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @job = Job.find(params[:id])
    @title = @job.name
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      @job.create_activity(:update, owner: current_user)
      flash[:notice] = "Job updated"
      redirect_to account_job_path(@account, @job)
    else
      flash[:alert] = "Job could not be saved: #{@job.errors.full_messages.uniq.join}"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @account = @job.account
    if @job.destroy
      redirect_to account_path(@account), alert: "Job destroyed"
    end
  end

  protected

  def job_params
    params.require(:job).permit(:account_id, :address_1, :address_2, :city, :state, :zip)
  end

  def filter_params
    params.except(:controller, :action, :account_id, :id)
  end

  def build_json_for_accounts
    @accounts.map do |account|
      {
        text: account.full_name,
        value: account.id,
        selected: false,
        imageSrc: account.avatar
      }
    end.to_json
  end

end
