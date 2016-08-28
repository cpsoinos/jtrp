class AgreementsController < ApplicationController
  before_filter :require_internal, except: [:show, :update]
  before_filter :find_proposal, only: [:index, :create]
  before_filter :find_job, only: [:create]
  before_filter :find_account, only: [:create]
  before_filter :pull_intentions, only: :create

  def index
    @job = @proposal.job
    @account = @job.account
    @client = @job.account.primary_contact
    @agreements = @proposal.agreements
    @items = @proposal.items
  end

  def show
    @agreement = Agreement.find(params[:id])
    @proposal = @agreement.proposal
    @job = @proposal.job
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
      respond_to do |format|
        format.html do
          flash[:notice] = "Agreement updated!"
          redirect_to agreement_path(@agreement)
        end
        format.js do
          @role = params[:role]
        end
      end
    end
  end

  def send_email
    @agreements = Agreement.where(id: params[:ids])
    @agreements.each do |agreement|
      TransactionalEmailJob.perform_later(agreement, current_user, agreement.account.primary_contact, "send_agreement", params[:note])
    end
    redirect_to :back, notice: "Email sent to client!"
  end

  protected

  def agreement_params
    params.require(:agreement).permit(:manager_agreed, :manager_agreed_at, :client_agreed, :client_agreed_at)
  end

  def pull_intentions
    @intentions = @proposal.items.pluck(:client_intention).uniq
  end

end
