class ClientsController < ApplicationController
  before_filter :require_internal

  def show
    @client = User.find(params[:id])
    @account = @client.account
    @maps_url = GeolocationService.new(@client).static_map_url
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      flash[:notice] = "Client created!"
      redirect_to account_path(@client.account)
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
      redirect_to account_client_path(@client.account, @client)
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_to :back
    end
  end

  protected

  def client_params
    params.require(:client).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :account_id])
  end

end
