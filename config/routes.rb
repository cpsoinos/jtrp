Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'categories#index'

  resources :categories do
    resources :items
  end

  resources :items do
    get '/tag', to: 'items#tag', as: 'tag'
  end

  resources :users_admin, controller: "users"

  resources :proposals do
    resources :items
    get '/consignment_agreement', to: 'proposals#consignment_agreement'
  end
  post '/create_client', to: 'proposals#create_client'
  put '/proposals/:proposal_id/add_existing_item', to: 'proposals#add_existing_item'

  resources :purchase_orders do
    resources :items
  end
  post '/create_vendor', to: 'purchase_orders#create_vendor'
  put '/purchase_orders/:purchase_order_id/add_existing_item', to: 'purchase_orders#add_existing_item'

end
