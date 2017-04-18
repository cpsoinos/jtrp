class AccountsController < ApplicationController
  before_filter :require_internal

  def index
    @accounts = Account.includes([:primary_contact, jobs: { proposals: :items }]).order("users.last_name")
    @title = "Accounts"
  end

  def show
    @account = Account.find(params[:id])
    @title = @account.full_name
    if @account.slug == 'jtrp'
      @items = Item.jtrp.page(params[:page])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def new
    @account = Account.new
    @title = "New Account"
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      @account.create_activity(:create, owner: current_user)
      flash[:notice] = "Account created"
      if @account.primary_contact
        render :show
      else
        redirect_to new_client_path(account_id: @account.id)
      end
    else
      redirect_to :back
    end
  end

  def edit
    @account = Account.find(params[:id])
    @title = @account.full_name
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      @account.create_activity(:update, owner: current_user)
      flash[:notice] = "Account updated"
      if @account.primary_contact
        render :show
      else
        redirect_to new_client_path(account_id: @account.id)
      end
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
    params.require(:account).permit(:is_company, :company_name, :primary_contact_id, :notes)
  end

end
