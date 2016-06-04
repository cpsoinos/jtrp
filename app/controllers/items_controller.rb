class ItemsController < ApplicationController
  before_filter :find_clients, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit]
  before_filter :find_proposal, only: [:create, :batch_create]
  before_filter :require_internal, only: [:new, :create, :update, :destroy]

  def index
    @items = ItemsPresenter.new(params).filter
    @intentions = @items.pluck(:client_intention).uniq
    intentions_map
    @filter = params[:state].try(:capitalize)
  end

  def new
    @item = Item.new
  end

  def create
    @item = ItemCreator.new(@proposal).create(item_params)
    respond_to do |format|
      if @item.persisted?
        format.html do
          flash[:notice] = "Item created"
          redirect_to item_path(@item)
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

  def batch_create
    if ItemImporter.new(@proposal).import(archive_params[:archive])
      flash[:notice] = "Items imported"
      redirect_to edit_proposal_path(@proposal)
    else
      flash[:alert] = "Upload failed"
      render :edit
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
  end

  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if ItemUpdater.new(@item).update(item_params)
        format.js do
          render 'proposals/add_item' if @item.proposal_id
          render 'proposals/remove_item' if @item.proposal_id == nil
        end
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.json { respond_with_bip(@item) }
      else
        format.html do
          flash[:alert] = 'Could not update item.'
          render :edit
        end
        format.json { respond_with_bip(@item) }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    filter = @item.state
    if @item.destroy
      flash[:notice] = "Item removed"
      redirect_to items_path(state: filter)
    else
      redirect_to :back
    end
  end

  def tag
    @item = Item.find(params[:item_id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "tag"
      end
    end
  end

  protected

  def item_params
    params.require(:item).permit(:description, {photos: []}, {initial_photos: []}, {listing_photos: []}, :proposal_id, :account_id, :purchase_price, :asking_price, :listing_price, :sale_price, :minimum_sale_price, :condition, :category_id, :client_intention, :notes, :height, :width, :depth, :offer_type)
  end

  def archive_params
    params.require(:item).permit(:archive)
  end

  def intentions_map
    @intentions_map = {
      "consign" => "consigned",
      "sell" => "owned",
      "donate" => "will donate",
      "dump" => "will dump",
      "move" => "will move",
      "undecided" => "undecided"
    }
  end

end
