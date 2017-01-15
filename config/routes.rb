require 'sidekiq/web'

Rails.application.routes.draw do

  match '*path', via: :all, to: 'errors#not_found',
    constraints: CloudfrontConstraint.new

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount RedisBrowser::Web => '/redis_browser'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'passthrough#index'

  get '/home', to: 'companies#home', as: 'landing_page'
  get '/about', to: 'companies#about', as: 'about'
  get '/contact', to: 'companies#contact', as: 'contact'
  post '/contact_us', to: 'companies#contact_us', as: 'contact_us'
  get '/dashboard', to: 'companies#show', as: 'dashboard'
  get '/client_services', to: 'companies#client_services', as: 'client_services'
  get '/consignment_policies', to: 'companies#consignment_policies', as: 'consignment_policies'
  get '/service_rate_schedule', to: 'companies#service_rate_schedule', as: 'service_rate_schedule'
  get '/agent_service_rate_schedule', to: 'companies#agent_service_rate_schedule', as: 'agent_service_rate_schedule'

  resources :companies

  resources :categories do
    resources :items
  end

  resources :photos, only: [:create, :destroy] do
    post '/batch_create', to: 'photos#batch_create', on: :collection
  end

  get '/batch_create', to: 'items#batch_create', as: 'items_batch_create'
  get '/csv_import', to: 'items#csv_import', as: 'items_csv_import'
  resources :items do
    post '/activate', to: 'items#activate', as: 'activate'
    patch '/deactivate', to: 'items#deactivate', as: 'deactivate'
    post '/mark_not_sold', to: 'items#mark_not_sold', as: 'mark_not_sold'
    get '/labels', to: 'items#labels', on: :collection
  end

  resources :accounts do
    resources :clients
    resources :transactions
    resources :items, only: :index
    resources :proposals, only: :new
    resources :jobs do
      resources :proposals do
        get '/sort_items', to: 'proposals#sort_items', as: "sort_items"
        get '/details', to: 'proposals#details', as: "details"
        get '/response_form', to: 'proposals#response_form'
        resources :agreements
        resources :items
      end
    end
    resources :statements, only: [:index, :show, :update] do
      post '/send_email', to: 'statements#send_email', as: 'send_email'
    end
    resources :letters, only: [:index, :show]
    post '/deactivate', to: 'accounts#deactivate', as: 'deactivate'
    post '/reactivate', to: 'accounts#reactivate', as: 'reactivate'
  end

  resources :statements do
    get '/statements_list', to: 'statements#statements_list', as: 'statements_list', on: :collection
  end

  resources :clients
  resources :jobs
  resources :proposals, only: [:index, :show] do
    post '/send_email', to: 'proposals#send_email', as: 'send_email'
    post '/notify_response', to: 'proposals#notify_response', as: 'notify_response'
  end
  resources :archives

  resources :users_admin, controller: "users"
  resources :users, only: [:show, :edit]

  resources :proposals do
    resources :items
    resources :agreements
    get '/details', to: 'proposals#details', as: "details"
    get '/response_form', to: 'proposals#response_form'
    get '/agreement', to: 'proposals#agreement'
  end
  post '/create_client', to: 'proposals#create_client'
  put '/proposals/:proposal_id/add_existing_item', to: 'proposals#add_existing_item'

  resources :agreements do
    get '/agreements_list', to: 'agreements#agreements_list', as: 'agreements_list', on: :collection
    post '/send_email', to: 'agreements#send_email', as: 'send_email'
    post '/activate_items', to: 'agreements#activate_items', as: "activate_items"
    resources :scanned_agreements, only: [:create, :update, :show, :destroy]
    resources :letters, only: [:create]
  end

  post '/:integration_name' => 'webhooks#receive', as: :receive_webhooks

  resources :search
  resources :purchases, only: [:index, :show]

end
