Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'categories#index'

  resources :categories do
    resources :items
  end

  resources :items

  resources :users_admin, controller: "users"

  resources :proposals do
    resources :items
    get '/consignment_agreement', to: 'proposals#consignment_agreement'
  end
  post '/create_client', to: 'proposals#create_client'

end
