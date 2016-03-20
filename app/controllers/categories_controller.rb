class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @company = @category.company
  end

end
