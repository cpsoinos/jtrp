class CompaniesController < ApplicationController

  def show
    @company = Company.find(params[:id])
    @categories = @company.categories
  end

end
