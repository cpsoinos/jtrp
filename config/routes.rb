Rails.application.routes.draw do
  root 'companies#index'

  resources :companies, only: [:show]
  resources :categories, only: [:show] do
    resources :items
  end

end
