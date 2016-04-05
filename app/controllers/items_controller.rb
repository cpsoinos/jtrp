class ItemsController < ApplicationController
  before_filter :find_category
  before_filter :find_company
  before_filter :require_internal, only: [:new, :create, :update, :destroy]

  def new
    @category = Category.find(params[:category_id])
    @item = @category.items.new
  end

  def create
    @item = @category.items.new(item_params)
    if @item.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Item created"
          redirect_to category_item_path(@category, @item)
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

  protected

  def item_params
    params.require(:item).permit([:name, :description, {initial_photos: []}, {listing_photos: []}, :purchase_price, :asking_price, :listing_price, :sale_price, :minimum_sale_price, :condition])
  end

end
