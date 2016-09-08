class StatementsController < ApplicationController
  before_filter :find_account

  def index
    @statements = @account.statements
  end

  def show
    @statement = Statement.find(params[:id])
    @client = @account.client
  end

end
