Rails.application.routes.draw do
  resources :users, only: [:show]

  get 'profile', to: 'user#show', as: :user_profile
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
