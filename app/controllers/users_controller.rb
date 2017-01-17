class UsersController < ApplicationController
  before_filter :find_user
  before_filter :ensure_manage

  def show
  end

  def edit
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  def ensure_manage
    current_user.try(:internal?) || current_user == @user
  end

end
