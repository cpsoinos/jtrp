class ClientsController < ApplicationController
  before_action :require_internal

  def show
    @client = User.find(params[:id])
    @account = @client.account || Account.find_by(primary_contact_id: params[:id])
    @maps_url = GeolocationService.new(@client).static_map_url
    @title = @client.full_name
  end

  def new
    if params[:account_id]
      @account = Account.find(params[:account_id])
    end
    @client = Client.new
    @title = "New Client"
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      @client.create_activity(:create, owner: current_user)
      set_primary_contact
      flash[:notice] = "Client created!"
      redirect_to account_path(@client.account)
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @client = Client.find(params[:id])
    @title = @client.full_name
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      @client.create_activity(:update, owner: current_user)
      flash[:notice] = "Client updated"
      redirect_to account_client_path(@client.account, @client)
    else
      flash[:alert] = @client.errors.full_messages.uniq.join
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_primary_contact
    account = @client.account
    account.primary_contact ||= @client
    account.save
  end

  protected

  def client_params
    params.require(:client).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :account_id])
  end

end
