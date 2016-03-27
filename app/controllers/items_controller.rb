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
      flash[:notice] = "Item created"
      redirect_to category_item_path(@category, @item)
    else
      flash[:error] = "Item could not be saved"
      redirect_to :back
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  protected

  def item_params
    params.require(:item).permit([:name, :description])
  end

end
