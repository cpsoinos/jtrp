class CategoriesController < ApplicationController
  before_filter :require_internal, except: [:index, :show]

  def index
    @categories = Category.all
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

  protected

  def category_params
    params.require(:category).permit([:name, :photo])
  end

end
