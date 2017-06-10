class UsersController < ApplicationController
  before_action :find_user
  before_action :ensure_manage
  layout 'ecommerce'

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Update successful!"
    else
      redirect_back(fallback_location: root_path, notice: "Unable to update user.")
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :avatar)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def ensure_manage
    unless (current_user.try(:internal?) || current_user == @user)
      redirect_back(fallback_location: root_path, alert: "You do not have access to this page.")
    end
  end

end
