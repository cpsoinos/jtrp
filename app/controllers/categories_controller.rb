class CategoriesController < ApplicationController
  before_filter :require_internal, except: [:index, :show]

  def index
    @items = Item.active.sample(3)
    @message = Message.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category created!"
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = "Category updated!"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Cagegory.find(params[:id])
    if @category.destroy
      flash[:notice] = "Category destroyed"
      redirect_to categories_path
    else
      flash[:notice] = "Category could not be destroyed"
      redirect_to :back
    end
  end

  protected

  def category_params
    params.require(:category).permit([:name, :photo, :parent_id])
  end

end
