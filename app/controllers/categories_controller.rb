class CategoriesController < ApplicationController
  # before_filter :find_company

  def show
    @category = Category.find(params[:id])
    @company = @category.company
  end

  def new
    @category = Category.new
  end

end
