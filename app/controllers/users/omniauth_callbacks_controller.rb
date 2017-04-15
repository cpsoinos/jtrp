class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def clover
    @oauth_account = OauthService.new(request.env["omniauth.auth"]).execute
    @user = @oauth_account.user

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Clover") if is_navigational_format?
    else
      session["devise.clover_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    set_flash_message :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to new_user_session__url
  end

end
