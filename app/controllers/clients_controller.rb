class ClientsController < ApplicationController
  before_filter :require_internal

  def index
    @clients = ClientsPresenter.new(params).filter
  end

  def show
    @client = User.find(params[:id])
  end

end
