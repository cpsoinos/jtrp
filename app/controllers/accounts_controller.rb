class AccountsController < ApplicationController
  before_action :require_internal

  def index
    params[:status] ||= "potential"
    @accounts = AccountsPresenter.new(params).execute
    gon.accounts = @accounts.includes(:proposals).as_json
    @title = "Accounts"
  end

  def show
    @account = Account.includes(:jobs, :proposals, :agreements, :statements).find(params[:id])
    @title = @account.full_name
    @jobs = @account.jobs
    @proposals = @account.proposals
    @agreements = @account.agreements
    @statements = @account.statements
    if @account.slug == 'jtrp'
      @items = Item.jtrp.page(params[:page])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def account_items_list
    @account = Account.find(params[:account_id])
    @items = @account.items.includes(:account, :job, :proposal)
    render partial: "account_items_list"
  end

  def new
    @account = Account.new
    @title = "New Account"
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      @title = @account.full_name
      @account.create_activity(:create, owner: current_user)
      flash[:notice] = "Account created"
      if @account.primary_contact
        redirect_to account_path(@account)
      else
        redirect_to new_client_path(account_id: @account.id)
      end
    else
      flash[:alert] = @account.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @account = Account.find(params[:id])
    @title = @account.full_name
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      @title = @account.full_name
      @account.create_activity(:update, owner: current_user)
      flash[:notice] = "Account updated"
      if @account.primary_contact
        redirect_to account_path(@account)
      else
        redirect_to new_client_path(account_id: @account.id)
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.destroy
      flash[:warning] = "Account destroyed"
      redirect_to accounts_path
    else
      flash[:warning] = "Account could not be destroyed. Please contact support."
      redirect_back(fallback_location: root_path)
    end
  end

  def expire
    @account = Account.find(params[:account_id])
    if @account.mark_expired
      redirect_back(fallback_location: root_path, notice: "Account expired")
    else
      redirect_back(fallback_location: root_path, alert: "Could not expire account.")
    end
  end

  def deactivate
    @account = Account.find(params[:account_id])
    if @account.mark_inactive
      redirect_back(fallback_location: root_path, notice: "Account deactivated")
    else
      redirect_back(fallback_location: root_path, alert: "Could not deactivate account.")
    end
  end

  def reactivate
    @account = Account.find(params[:account_id])
    if @account.reactivate
      redirect_back(fallback_location: root_path, notice: "Account reactivated")
    else
      redirect_back(fallback_location: root_path, alert: "Could not reactivate account.")
    end
  end

  protected

  def account_params
    params.require(:account).permit(:is_company, :company_name, :primary_contact_id, :notes)
  end

end
