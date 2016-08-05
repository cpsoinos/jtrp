class PassthroughController < ApplicationController

  def index
    if current_user.try(:internal?)
      redirect_to dashboard_path
    else
      redirect_to landing_page_path
    end
  end

end
