class ProposalsController < ApplicationController
  before_filter :require_internal, except: [:show]

  def new
    @proposal = Proposal.new
    @clients = clients
    @client = User.new
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      render :new
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
    @items = @proposal.items
  end

  def edit
    @proposal = Proposal.find(params[:id])
  end

  def consignment_agreement
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
  end

  def create_client
    @client = User.new(user_params)
    @client.skip_password_validation = true
    @client.role = "client"
    if @client.save
      @proposal = Proposal.new(client: @client, created_by: current_user)
      if @proposal.save
        redirect_to edit_proposal_path(@proposal)
      else
        redirect_to :back
      end
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_to new_proposal_path
    end
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

  def user_params
    params.require(:user).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext])
  end

end
