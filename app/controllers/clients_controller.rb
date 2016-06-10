class ClientsController < ApplicationController
  before_filter :require_internal

  def show
    @client = User.find(params[:id])
    @maps_url = GeolocationService.new(@client).static_map_url
  end

  def new
    @client = Client.new
  end

  def create
    @client = ClientCreator.new(current_user).create(client_params, params[:proposal])

    if @client.errors.empty?
      flash[:notice] = "Client created!"
      if params[:proposal]
        redirect_to edit_proposal_path(@client.proposals.first)
      else
        redirect_to account_path(@client.account)
      end
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_to :back
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      flash[:notice] = "Client updated"
      render :show
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_to :back
    end
  end

  protected

  def client_params
    params.require(:client).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext])
  end

end
