Rails.application.routes.draw do
  devise_for :users
  root 'categories#index'

  resources :categories do
    resources :items
  end

  resources :proposals do
    resources :items
    get '/consignment_agreement', to: 'proposals#consignment_agreement'
  end

end
