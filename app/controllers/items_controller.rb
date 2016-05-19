class ItemsController < ApplicationController
  before_filter :find_clients, only: [:new, :edit]
  before_filter :find_categories, only: [:new, :edit]
  before_filter :find_proposal, only: :create
  before_filter :require_internal, only: [:new, :create, :update, :destroy]

  def index
    @items = ItemsPresenter.new(params).filter
    @filter = params[:state].try(:capitalize)
  end

  def new
    @item = Item.new
  end

  def create
    @item = item_creator

    if @item.save
      respond_to do |format|
        if params[:initial_photos]
          params[:initial_photos].each do |photo|
            @item.photos.create!(photo: photo, photo_type: "initial")
          end
        end
        if params[:listing_photos]
          params[:listing_photos].each do |photo|
            @item.photos.create!(photo: photo, photo_type: "listing")
          end
        end
        format.html do
          flash[:notice] = "Item created"
          redirect_to item_path(@item)
        end
        format.js do
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
      if params[:item][:initial_photos]
        params[:item][:initial_photos].each do |photo|
          @item.photos.create!(photo: photo, photo_type: "initial")
        end
      end
      if params[:item][:listing_photos]
        params[:item][:listing_photos].each do |photo|
          @item.photos.create!(photo: photo, photo_type: "listing")
        end
      end
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
    filter = @item.state
    if @item.destroy
      flash[:notice] = "Item removed"
      if params[:redirect_url]
        redirect_to(params[:redirect_url])
      else
        redirect_to items_path(state: filter)
      end
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
    params.require(:item).permit(:name, :description, {initial_photos_attributes: [:id, :initial_photo_id, :initial_photo]}, {listing_photos_attributes: [:id, :listing_photo_id, :listing_photo]}, :purchase_price, :asking_price, :listing_price, :sale_price, :minimum_sale_price, :condition, :client_id, :category_id, :client_intention, :notes, :height, :width, :depth)
  end

  def item_creator
    if @proposal
      @proposal.items.new(item_params)
    else
      Item.new(item_params)
    end
  end

end
