class AccountsController < ApplicationController
  before_filter :require_internal

  def index
    @accounts = Account.includes(:primary_contact).order("users.last_name")
  end

  def show
    @account = Account.find(params[:id])
    if @account.slug == 'jtrp'
      @items = Item.jtrp
    end
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

  def deactivate
    @account = Account.find(params[:account_id])
    if @account.mark_inactive
      redirect_to :back, notice: "Account deactivated"
    else
      redirect_to :back, alert: "Could not deactivate account."
    end
  end

  def reactivate
    @account = Account.find(params[:account_id])
    if @account.reactivate
      redirect_to :back, notice: "Account reactivated"
    else
      redirect_to :back, alert: "Could not reactivate account."
    end
  end

  protected

  def account_params
    params.require(:account).permit(:is_company, :company_name, :notes)
  end

end
