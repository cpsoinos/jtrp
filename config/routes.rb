require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
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

  resources :photos, only: :destroy

  get '/batch_create', to: 'items#batch_create', as: 'items_batch_create'
  resources :items do
    get '/tag', to: 'items#tag', as: 'tag'
    get '/tags', to: 'items#tags', on: :collection
  end

  resources :accounts do
    resources :clients
    resources :transactions
    resources :items, only: :index
    resources :proposals, only: :new
    resources :jobs do
      resources :proposals do
        get '/details', to: 'proposals#details', as: "details"
        get '/response_form', to: 'proposals#response_form'
        resources :agreements
        resources :items
      end
    end
  end

  resources :clients
  resources :jobs
  resources :proposals, only: [:index, :show]
  resources :archives

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
    resources :scanned_agreements, only: [:create, :show, :destroy]
  end

  post '/:integration_name' => 'webhooks#receive', as: :receive_webhooks

  resources :search

end
