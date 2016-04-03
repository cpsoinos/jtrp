class ProposalsController < ApplicationController
  before_filter :require_internal, except: [:show]

  def new
    @proposal = Proposal.new
    @clients = clients
    @items = items
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      render :new
    end
  end

  def edit
    @proposal = Proposal.find(params[:id])
  end

  def consignment_agreement
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
  end

  private

  def clients
    @clients = User.client.map do |client|
      [client.full_name, client.id]
    end
  end

  def items
    @items = Item.potential.map do |item|
      [item.name, item.id]
    end
  end

  protected

  def proposal_params
    params.require(:proposal).permit([:client_id, :created_by_id])
  end

end
