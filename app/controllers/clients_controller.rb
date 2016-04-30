class ClientsController < ApplicationController
  before_filter :require_internal

  def index
    # @clients = ClientsPresenter.new(params).filter
    @clients = User.client
    @filter = params[:status].try(:capitalize)
  end

  def show
    @client = User.find(params[:id])
  end

end
