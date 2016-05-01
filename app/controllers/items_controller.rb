class ItemsController < ApplicationController
  before_filter :find_clients, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit]
  before_filter :find_proposal, only: :create
  before_filter :find_purchase_order, only: :create
  before_filter :require_internal, only: [:new, :create, :update, :destroy]

  def index
    @items = ItemsPresenter.new(params).filter
    @filter = params[:state].try(:capitalize)
  end

  def new
    @item = Item.new
  end

  def create
    @item = begin
      if find_proposal
        @proposal.items.new(item_params)
      elsif find_purchase_order
        @purchase_order.items.new(item_params)
      else
        Item.new(item_params)
      end
    end
    if @item.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Item created"
          redirect_to item_path(@item)
        end
        format.js do
          @proposal = Proposal.find(params[:proposal_id])
          render :'proposals/add_item'
        end
      end
    else
      flash[:alert] = "Item could not be saved"
      redirect_to :back
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.update(item_params)
        format.js { render nothing: true }
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.json { respond_with_bip(@item) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@item) }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @proposal = Proposal.find(params[:proposal_id])
    if @item.destroy
      flash[:notice] = "Item removed"
      redirect_to proposal_path(@proposal)
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
    params.require(:item).permit([:name, :description, {initial_photos: []}, {listing_photos: []}, :purchase_price, :asking_price, :listing_price, :sale_price, :minimum_sale_price, :condition, :client_id, :category_id, :client_intention])
  end

end
