# frozen_string_literal: true

Rails.application.routes.draw do
  resources :teams

  devise_for :users

  get 'profile', to: 'user#show', as: :user_profile
  get 'profile/edit', to: 'user#edit', as: :edit_user_profile
  patch 'profile', to: 'user#update'
  delete 'profile', to: 'user#destroy', as: :delete_user_profile

  get 'create_team', to: 'teams#new', as: :create_team

  get 'dashboard', to: 'dashboard#index', as: :dashboard

  scope '/dashboard' do
    get '/:id/site-admin', to: 'admin#index', as: :admin_page
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  post 'visitor-tracker', to: 'pages#visitors'
end
