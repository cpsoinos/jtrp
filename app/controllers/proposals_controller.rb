class ProposalsController < ApplicationController
  before_filter :find_clients, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit]
  before_filter :require_internal, except: [:show]

  def new
    @proposal = Proposal.new
    @client = User.new
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      flash[:alert] = @proposal.errors.full_messages.uniq.join
      @client = Client.new
      render :new
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
    @client = @proposal.client
    @items = @proposal.items
  end

  def edit
    @proposal = Proposal.find(params[:id])
    @client = @proposal.client
    @item = @proposal.items.new
    @items = @proposal.items
    gon.items = build_json_for_items
    gon.proposalId = @proposal.id
  end

  def response_form
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
    @items = @proposal.items.order(:id)
  end

  def create_client
    @client = Client.new(user_params)
    @client.skip_password_validation = true
    if @client.save
      @proposal = Proposal.new(client: @client, created_by: current_user)
      if @proposal.save
        redirect_to edit_proposal_path(@proposal)
      else
        render :new
      end
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_to new_proposal_path
    end
  end

  protected

  def proposal_params
    params.require(:proposal).permit([:client_id, :created_by_id])
  end

  def user_params
    params.require(:user).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext])
  end

  def build_json_for_items
    @client.items.potential.map do |item|
      {
        text: item.name,
        value: item.id,
        selected: false,
        description: item.description,
        imageSrc: item.initial_photos.first.try(:thumb).try(:url)
      }
    end.to_json
  end

end
