describe "home#register as a provider", :type => :request do

  it "redirects to oauth#callback" do
    get '/users/auth/clover'
    expect(response).to redirect_to(user_omniauth_callback_path(:clover))
  end

end
