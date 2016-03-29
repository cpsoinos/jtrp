Rails.application.routes.draw do
  devise_for :users
  root 'companies#index'

  resources :companies, only: [:show]
  resources :categories do
    resources :items
  end

end
