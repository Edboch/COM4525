# frozen_string_literal: true

Rails.application.routes.draw do
  resources :teams

  resources :teams do
    resources :user_teams
  end

  resources :user_teams do
    member do
      post 'accept'
      delete 'reject'
    end
  end

  devise_for :users

  get 'profile', to: 'user#show', as: :user_profile
  get 'profile/edit', to: 'user#edit', as: :edit_user_profile
  patch 'profile', to: 'user#update'
  delete 'profile', to: 'user#destroy', as: :delete_user_profile

  get 'create_team', to: 'teams#new', as: :create_team

  get 'teams/:id/players', to: 'teams#players', as: :team_players
  delete 'teams/:team_id/players/:user_id', to: 'user_teams#destroy', as: 'remove_team_player'

  get 'player/invites', to: 'players#invites', as: :player_invites

  get 'dashboard', to: 'dashboard#index', as: :dashboard

  scope '/dashboard' do
    get '/:id/site-admin', to: 'admin#index', as: :admin_page
  end

  scope '/metrics' do
    post '/popularity', to: 'admin#retrieve_popularity_metrics', as: :metrics_popularity
  end

  scope '/admin' do
    post '/all-users', to: 'admin#retrieve_users', as: :admin_all_users
    post '/update-user', to: 'admin#update_user', as: :admin_update_user
    post '/remove-user', to: 'admin#remove_user', as: :admin_remove_user
    post '/unsolved-reports', to: 'admin#retrieve_unsolved_reports', as: :admin_unsolved_reports
    post '/solved-reports', to: 'admin#retrieve_solved_reports', as: :admin_solved_reports

    post '/remove-report', to: 'admin#remove_report', as: :admin_remove_report
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  post 'visitor-tracker', to: 'pages#visitors'
end
