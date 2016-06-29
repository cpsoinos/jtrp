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
    gon.signatures = build_json_for_signatures
  end

  def show
    @agreement = Agreement.find(params[:id])
    @account = @agreement.proposal.job.account
    @client = @account.primary_contact
    @agreements = [@agreement]
    gon.signatures = build_json_for_signatures
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
    binding.pry
    if @agreement.update(signature_params)
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

  def signature_params
    key = "#{params[:role]}_signature".to_sym
    { key => params[:signature] }
  end

  def build_json_for_signatures
    signatures = begin
      @agreements.each do |agreement|
        {
          manager: agreement.manager_signature,
          client: agreement.client_signature
        }
      end
    end
    signatures
  end

  def pull_intentions
    @intentions = @proposal.items.pluck(:client_intention).uniq
  end

end
