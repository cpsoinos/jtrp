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
      render :new
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
    @items = @proposal.items
  end

  def edit
    @proposal = Proposal.find(params[:id])
    @client = @proposal.client
    @item = @proposal.items.new
    gon.items = build_json_for_items
    gon.proposalId = @proposal.id
  end

  def consignment_agreement
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
    gon.signatures = build_json_for_signatures
  end

  def update
    @proposal = Proposal.find(params[:id])
    if @proposal.update(signature_params)
      respond_to do |format|
        format.html
        format.js do
          @role = params[:role]
        end
      end
    end
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

  def add_existing_item
    @item = Item.find(params[:item][:id])
    if @item.update(item_params)
      respond_to do |format|
        format.js do
          @proposal = @item.proposal
          render :'proposals/add_item'
        end
      end
    end
  end

  protected

  def proposal_params
    params.require(:proposal).permit([:client_id, :created_by_id])
  end

  def signature_params
    key = "#{params[:role]}_signature".to_sym
    { key => params[:signature] }
  end

  def build_json_for_signatures
    signatures = {
      manager: @proposal.manager_signature,
      client: @proposal.client_signature
    }

    signatures
  end

  def user_params
    params.require(:user).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext])
  end

  def item_params
    params.require(:item).permit([:proposal_id])
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
