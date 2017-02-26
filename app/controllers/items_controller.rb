require 'prawn/labels'

class ItemsController < ApplicationController
  layout :resolve_layout
  before_filter :find_clients, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit, :show, :index]
  before_filter :find_proposal, only: [:create, :batch_create]
  before_filter :require_internal, except: [:show, :update]
  before_filter :find_item, only: :show

  def index
    filter_params = params
    if params[:status] == "all"
      filter_params = params.except(:status)
    end
    @filter = params[:status].try(:capitalize)
    @type = params[:type]
    @items = ItemsPresenter.new(filter_params).execute
  end

  def new
    @item = Item.new
  end

  def create
    @item = ItemCreator.new(@proposal).create(item_params)
    @proposal = @item.proposal
    @job = @proposal.job
    @account = @job.account
    respond_to do |format|
      if @item.persisted?
        format.html do
          flash[:notice] = "Item created"
          if @item.child?
            redirect_to account_job_proposal_item_path(@account, @job, @proposal, @item)
          else
            redirect_to account_job_proposal_sort_items_path(@account, @job, @proposal)
          end
        end
        format.js do
          render :'proposals/add_item'
        end
      else
        format.html do
          flash[:alert] = "Item could not be saved"
          render :new
        end
        format.js do
          render nothing: true
        end
      end
    end
  end

  def show
    meta_tags
    if current_user.try(:internal?)
      @child_item = @item.build_child_item
    else
      render :sapphire_show
    end
  end

  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
  end

  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if ItemUpdater.new(@item).update(item_params) && !@item.errors.present?
        format.js do
          @message = "#{@item.description} updated!"
          render 'proposals/update_item_details'
        end
        format.html do
          notice = 'Item was successfully updated.'
          if params[:redirect_url]
            redirect_to(params[:redirect_url], notice: notice)
          else
            redirect_to(@item, notice: notice)
          end
        end
        format.json { respond_with_bip(@item) }
      else
        format.html do
          flash[:alert] = 'Could not update item.'
          redirect_to edit_account_job_proposal_item_path(@item.account, @item.job, @item.proposal, @item)
        end
        format.json { respond_with_bip(@item) }
      end
    end
  end

  def activate
    @item = Item.find(params[:item_id])
    if @item.mark_active
      redirect_to :back, notice: "Item activated!"
    else
      redirect_to :back, alert: "Could not activate item. Check that the agreement is active first."
    end
  end

  def deactivate
    @item = Item.find(params[:item_id])
    if @item.mark_inactive and @item.update(item_params)
      redirect_to :back, notice: "Item deactivated"
    else
      redirect_to :back, alert: "Could not deactivate item."
    end
  end

  def mark_not_sold
    @item = Item.find(params[:item_id])
    if @item.mark_not_sold
      redirect_to :back, notice: "Item marked as not sold."
    else
      redirect_to :back, alert: "Could not mark item as not sold."
    end
  end

  def destroy
    @item = Item.find(params[:id])
    filter = @item.status
    if @item.destroy
      respond_to do |format|
        format.js do
          render 'proposals/remove_item'
        end
        format.html do
          flash[:notice] = "Item removed"
          redirect_to items_path(status: filter)
        end
      end
    else
      redirect_to :back
    end
  end

  def labels
    params[:labels] = true
    @items = ItemsPresenter.new(params).execute
    labels = LabelGenerator.new(@items).generate

    send_data labels, filename: "Item Labels", type: "application/pdf", disposition: "inline"
  end

  protected

  def item_params
    params.require(:item).permit(:description, {photos: []}, {initial_photos: []}, {listing_photos: []}, :purchase_price, :asking_price, :listing_price, :sale_price, :sold_at, :minimum_sale_price, :condition, :category_id, :client_intention, :notes, :will_purchase, :will_consign, :account_item_number, :consignment_rate, :proposal_id, :parent_item_id, :jtrp_number, :expired, :consignment_term, :parts_cost, :labor_cost, {tag_list: []}, :acquired_at)
  end

  def find_item
    @item = Item.find(params[:id])
  end

  def resolve_layout
    if !current_user.try(:internal?)
      if action_name.in?(%w(show))
        "ecommerce"
      end
    else
      "application"
    end
  end

end
