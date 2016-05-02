class ClientsController < ApplicationController
  before_filter :require_internal

  def index
    @clients = ClientsPresenter.new(params).filter
    @filter = params[:status].try(:capitalize)
  end

  def show
    @client = User.find(params[:id])
    @maps_url = GeolocationService.new(@client).static_map_url
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.skip_password_validation = true
    if @client.save
      flash[:notice] = "Client created!"
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
