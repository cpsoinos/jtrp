class ItemsController < ApplicationController
  before_filter :find_category
  before_filter :find_company
  before_filter :require_internal, only: [:new, :create, :update, :destroy]

  def new
    @category = Category.find(params[:category_id])
    @item = @category.items.new
  end

end
