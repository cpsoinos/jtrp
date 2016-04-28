class PassthroughController < ApplicationController

  def index
    if current_user.try(:internal?)
      redirect_to company_path(@company)
    else
      redirect_to categories_path
    end
  end

end
