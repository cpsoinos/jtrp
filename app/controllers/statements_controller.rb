class StatementsController < ApplicationController
  before_filter :find_account

  def index
    @statements = @account.statements
  end

  def show
    @statement = Statement.find(params[:id])
  end

end
