class AgreementsController < ApplicationController
  before_filter :require_internal, except: [:show, :update]
  before_filter :find_proposal, only: [:create, :send_email]
  before_filter :find_job, only: [:create]
  before_filter :find_account, only: [:create]
  before_filter :pull_intentions, only: :create

  def index
    @proposal = Proposal.includes(:account, :job, :agreements, account: :primary_contact).find(params[:proposal_id])
    @job = @proposal.job
    @account = @proposal.account
    @client = @proposal.account.primary_contact
    @agreements = @proposal.agreements
  end

  def show
    @agreement = Agreement.find(params[:id])
    require_token; return if performed?
    @proposal = @agreement.proposal
    @job = @proposal.job
    @account = @agreement.proposal.job.account
    @client = @account.primary_contact
    @agreements = [@agreement]
    @items = @agreement.items
  end

  def agreements_list
    @agreements = AgreementsPresenter.new(params).filter
    @intentions = @agreements.pluck(:agreement_type).uniq
  end

  def create
    @client = @account.primary_contact
    @agreements = AgreementCreator.new(current_user).create(@proposal)
    redirect_to account_job_proposal_agreements_path(@account, @job, @proposal)
  end

  def update
    @agreement = Agreement.find(params[:id])
    if @agreement.update(agreement_params)
      respond_to do |format|
        format.html do
          @agreement.mark_active # will return if does not meet requirements
          flash[:notice] = "Agreement updated!"
          redirect_to :back
        end
        format.js do
          @role = params[:role]
        end
        format.json { respond_with_bip(@agreement) }
      end
    end
  end

  def send_email
    @agreements = @proposal.agreements
    @agreements.each do |agreement|
      TransactionalEmailJob.perform_later(agreement, current_user, agreement.account.primary_contact, "send_agreement", params[:note])
    end
    redirect_to :back, notice: "Email sent to client!"
  end

  def activate_items
    @agreement = Agreement.find(params[:agreement_id])
    @agreement.items.map(&:mark_active)
    redirect_to :back, notice: "Items are marked active!"
  end

  def expire_items
    @agreement = Agreement.find(params[:agreement_id])
    ItemExpirerJob.perform_later(@agreement.items.pluck(:id))
    redirect_to :back, notice: "Items have been queued to be expired! They will appear under the JTRP account shortly."
  end

  protected

  def agreement_params
    params.require(:agreement).permit(:manager_agreed, :manager_agreed_at, :client_agreed, :client_agreed_at, :service_charge, :check_number)
  end

  def pull_intentions
    @intentions = @proposal.items.pluck(:client_intention).uniq
  end

  private

  def require_token
    unless (params[:token] == @agreement.token) || (@agreement.created_at < DateTime.parse("October 29, 2016"))
      require_internal
    end
  end

end
