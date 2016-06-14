class AccountsController < ApplicationController
  before_filter :require_internal

  def index
    @accounts = AccountsPresenter.new(params).filter
    @filter = params[:status]
    @yard_sale = Account.yard_sale
    @estate_sale = Account.estate_sale
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      flash[:notice] = "Account created"
      redirect_to account_path(@account)
    else
      redirect_to :back
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      flash[:notice] = "Account updated"
      redirect_to account_path(@account)
    else
      redirect_to :back
    end
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.destroy
      flash[:warning] = "Account destroyed"
      redirect_to accounts_path
    else
      flash[:warning] = "Account could not be destroyed. Please contact support."
      redirect_to :back
    end
  end

  protected

  def account_params
    params.require(:account).permit(:is_company, :company_name, :notes)
  end

end
