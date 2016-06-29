class AgreementsController < ApplicationController
  before_filter :require_internal
  before_filter :find_proposal, only: [:index, :create]
  before_filter :find_job, only: [:index, :create]
  before_filter :find_account, only: [:index, :create]
  before_filter :pull_intentions, only: :create

  def index
    @client = @proposal.job.account.primary_contact
    @agreements = @proposal.agreements
    @items = @proposal.items
  end

  def show
    @agreement = Agreement.find(params[:id])
    @account = @agreement.proposal.job.account
    @client = @account.primary_contact
    @agreements = [@agreement]
  end

  def agreements_list
    @agreements = AgreementsPresenter.new(params).filter
    @intentions = @agreements.pluck(:agreement_type).uniq
  end

  def create
    @client = @proposal.client
    @agreements = AgreementCreator.new(current_user).create(@proposal)
    redirect_to account_job_proposal_agreements_path(@account, @job, @proposal)
  end

  def update
    @agreement = Agreement.find(params[:id])
    if @agreement.update(agreement_params)
      @agreement.mark_active
      respond_to do |format|
        format.html do
          flash[:notice] = "Agreement updated!"
          redirect_to account_job_path(@agreement.account, @agreement.job)
        end
        format.js do
          @role = params[:role]
        end
      end
    end
  end

  protected

  def agreement_params
    params.require(:agreement).permit(:manager_agreed, :manager_agreed_at, :client_agreed, :client_agreed_at)
  end

  def pull_intentions
    @intentions = @proposal.items.pluck(:client_intention).uniq
  end

end
