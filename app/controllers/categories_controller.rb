class CategoriesController < ApplicationController
  layout :resolve_layout
  before_filter :require_internal, except: [:index, :show]

  def index
  end

  def show
    @category = Category.includes(:subcategories).find(params[:id])
    @items = find_items
    find_toggle_selector
    find_selected_selector
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
      redirect_to category_path(@category)
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.items.update_all(category_id: nil)
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
    params.require(:category).permit(:name, :parent_id, :photo)
  end

  def resolve_layout
    if action_name.in?(%w(show))
      "ecommerce"
    else
      "application"
    end
  end

  def find_items
    if @category.subcategory?
      @category.items.active.page(params[:page]).per(12)
    else
      Item.active.where(category_id: ([@category.id] | @category.subcategories.pluck(:id))).page(params[:page]).per(12)
    end
  end

  def find_toggle_selector
    gon.toggleSelector = begin
      if @category.subcategory?
        "#collapse-#{@category.parent.slug}"
      else
        "#collapse-#{@category.slug}"
      end
    end
  end

  def find_selected_selector
    gon.selectedSelector = "#selected-category-#{@category.slug}"
  end

end
