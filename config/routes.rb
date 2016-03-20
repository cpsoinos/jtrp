Rails.application.routes.draw do
  devise_for :users
  root 'companies#index'

  resources :companies, only: [:show]
  resources :categories, only: [:show] do
    resources :items
  end

end
