Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'passthrough#index'

  resources :companies do
    get '/about_us', to: 'companies#about_us', as: 'about_us'
    get '/consignment_policies', to: 'companies#consignment_policies', as: 'consignment_policies'
    get '/service_rate_schedule', to: 'companies#service_rate_schedule', as: 'service_rate_schedule'
    get '/agent_service_rate_schedule', to: 'companies#agent_service_rate_schedule', as: 'agent_service_rate_schedule'
  end

  resources :categories do
    resources :items
  end

  resources :items do
    get '/tag', to: 'items#tag', as: 'tag'
  end

  resources :clients

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
  put '/purchase_orders/:purchase_order_id/add_existing_item', to: 'purchase_orders#add_existing_item'

end
