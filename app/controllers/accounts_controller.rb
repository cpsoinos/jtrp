class AccountsController < ApplicationController
  before_filter :require_internal

  def index
    @accounts = AccountsPresenter.new(params).filter
    @yard_sale = Account.find(1)
    @estate_sale = Account.find(2)
  end

  def show
    @account = Account.find(params[:id])
  end

end
