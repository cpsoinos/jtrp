class ProposalsController < ApplicationController
  before_filter :find_accounts, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit]
  before_filter :find_account, :find_job
  before_filter :require_internal, except: [:show]

  def new
    @proposal = Proposal.new
    @client = Client.new
  end

  def create
    @proposal = @job.proposals.new(created_by: current_user)
    if @proposal.save
      redirect_to edit_account_job_proposal_path(@account, @job, @proposal)
    else
      flash[:alert] = @proposal.errors.full_messages.uniq.join
      redirect_to :back
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
    @client = @account.primary_contact
    @items = @proposal.items
  end

  def edit
    @proposal = Proposal.find(params[:id])
    @item = @proposal.items.new
    @items = @proposal.items
    gon.proposalId = @proposal.id
  end

  def details
    @proposal = Proposal.find(params[:proposal_id])
    @items = @proposal.items
  end

  def response_form
    @proposal = Proposal.find(params[:proposal_id])
    @account = @proposal.account
    @client = @account.primary_contact
    @items = @proposal.items.order(:id)
  end

  protected

  def proposal_params
    params.require(:proposal).permit([:job_id, :created_by_id])
  end

end
