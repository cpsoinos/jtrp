require 'prawn/labels'

class ItemsController < ApplicationController
  before_action :find_clients, only: [:new, :edit]
  before_action :find_categories, only: [:new, :edit, :show, :index, :discountable]
  before_action :find_proposal, only: [:create, :batch_create]
  # before_action :require_internal, except: [:show, :update, :feed]
  before_action :find_item, only: :show
  include Secured

  def index
    binding.pry
    @title = "Items"
    if filter_params[:status] == "all"
      filter_params.delete(:status)
    end
    @filter = params[:status].try(:capitalize)
    @type = params[:type]
    presenter = ItemsPresenter.new(filter_params)
    @items = presenter.execute

    respond_to do |format|
      format.html
      format.json do
        data = {
          total: Item.count,
          rows: @items.as_json(
            methods: [
              :description_link,
              :featured_photo_url,
              :humanized_purchase_price,
              :account_link,
              :humanized_minimum_sale_price,
              :humanized_listing_price,
              :humanized_sale_price
            ]
          )
        }
        render json: data
      end
    end
  end

  def discountable
    @title = "Discountable Items"
    @discount_amounts = [10, 20, 30, 40, 50]
    amount = params[:amount].try(:to_i)
    @items = Item.includes(:proposal, :job, :account).discountable(amount).page(params[:page])
  end

  def apply_discount
    @item = Item.find(params[:id])
    @amount = params[:amount]
    tag = "#{@amount}% Off"

    new_listing_price = @item.listing_price_cents * (1 - @amount.to_f / 100)

    if Items::Updater.new(@item).update(listing_price_cents: new_listing_price)
      @item.tag_list << tag
      @item.save
      @message = "#{@item.description.titleize} discounted by #{@amount}%"
    end
  end

  def feed
    respond_to do |format|
      format.csv do
        send_data ProductCatalogPresenter.new.build_csv
      end
    end
  end

  def new
    @item = Item.new
    @title = "New Item"
  end

  def create
    @item = Items::Creator.new(@proposal).create(item_params)
    @proposal = @item.proposal
    @job = @proposal.job
    @account = @job.account
    respond_to do |format|
      if @item.persisted?
        @item.create_activity(:create, owner: current_user)
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
    require_internal unless @item.active?
    meta_tags
    @title = @item.description.titleize
    @category = @item.category
    if current_user.try(:internal?)
      @child_item = @item.build_child_item
    end
    if @category
      @related_items = @item.category.items.active.where.not(id: @item.id).limit(3)
    end
  end

  def edit
    @item = Item.find(params[:id])
    @title = @item.description.titleize
    @categories = Category.all
  end

  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if Items::Updater.new(@item).update(item_params) && !@item.errors.present?
        @item.create_activity(:update, owner: current_user)
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

  def bulk_update
    @proposal = Proposal.find(params[:proposal_id])
    @account = @proposal.account
    @items = @account.items.where(client_intention: %w(decline undecided nothing))
    @items.each do |item|
      Items::Updater.new(item).update(proposal: @proposal)
      item.create_activity(:update, owner: current_user)
    end
    flash[:notice] = "Items imported"
    redirect_to account_job_proposal_details_path(@account, @proposal.job, @proposal)
  end

  def sync
    find_account
    item_ids = @account.items.pluck(:id)
    respond_to do |format|
      format.js do
        BulkSyncJob.perform_later(item_ids: item_ids)
        @message = "Syncing #{item_ids.count} to Clover in the background..."
      end
    end
  end

  def activate
    @item = Item.find(params[:item_id])
    if @item.mark_active
      redirect_back(fallback_location: root_path, notice: "Item activated!")
    else
      redirect_back(fallback_location: root_path, alert: "Could not activate item. Check that the agreement is active first.")
    end
  end

  def deactivate
    @item = Item.find(params[:item_id])
    if @item.mark_inactive and @item.update(item_params)
      redirect_back(fallback_location: root_path, notice: "Item deactivated")
    else
      redirect_back(fallback_location: root_path, alert: "Could not deactivate item.")
    end
  end

  def mark_not_sold
    @item = Item.find(params[:item_id])
    if @item.mark_not_sold
      redirect_back(fallback_location: root_path, notice: "Item marked as not sold.")
    else
      redirect_back(fallback_location: root_path, alert: "Could not mark item as not sold.")
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
      redirect_back(fallback_location: root_path)
    end
  end

  def labels
    opts = filter_params.merge(labels: true)
    @items = ItemsPresenter.new(opts).execute
    labels = LabelGenerator.new(@items).generate

    send_data labels, filename: "Item Labels", type: "application/pdf", disposition: "inline"
  end

  protected

  def item_params
    params.require(:item).permit(:description, {photos: []}, {initial_photos: []}, {listing_photos: []}, :purchase_price, :asking_price, :listing_price, :sale_price, :sold_at, :minimum_sale_price, :condition, :category_id, :client_intention, :notes, :will_purchase, :will_consign, :account_item_number, :consignment_rate, :proposal_id, :parent_item_id, :jtrp_number, :expired, :consignment_term, :parts_cost, :labor_cost, {tag_list: []}, :acquired_at)
  end

  def filter_params
    params.except(:controller, :action, :item)
  end

  def find_item
    @item = Item.find(params[:id])
  end

end
