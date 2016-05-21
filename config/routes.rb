Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'passthrough#index'

  resources :companies do
    get '/client_services', to: 'companies#client_services', as: 'client_services'
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
    resources :agreements
    get '/details', to: 'proposals#details', as: "details"
    get '/response_form', to: 'proposals#response_form'
    get '/agreement', to: 'proposals#agreement'
  end
  post '/create_client', to: 'proposals#create_client'
  put '/proposals/:proposal_id/add_existing_item', to: 'proposals#add_existing_item'

  resources :purchase_orders do
    resources :items
  end
  put '/purchase_orders/:purchase_order_id/add_existing_item', to: 'purchase_orders#add_existing_item'

  resources :agreements do
    get '/agreements_list', to: 'agreements#agreements_list', as: 'agreements_list', on: :collection
  end

end
