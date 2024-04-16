# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :teams

  resources :teams do
    resources :user_teams
    resources :matches
    get 'fixtures', to: 'matches#fixtures', as: :fixtures
  end

  resources :user_teams do
    member do
      post 'accept'
      delete 'reject'
    end
  end

  get 'profile', to: 'user#show', as: :user_profile
  get 'profile/edit', to: 'user#edit', as: :edit_user_profile
  patch 'profile', to: 'user#update'
  delete 'profile', to: 'user#destroy', as: :delete_user_profile

  get 'create_team', to: 'teams#new', as: :create_team

  get 'teams/:id/players', to: 'teams#players', as: :team_players
  delete 'teams/:team_id/players/:user_id', to: 'user_teams#destroy', as: 'remove_team_player'

  get 'player/invites', to: 'players#invites', as: :player_invites

  get 'player/upcoming_matches', to: 'players#upcoming_matches', as: :player_upcoming_matches

  get 'dashboard', to: 'dashboard#index', as: :dashboard

  scope '/metrics' do
    post '/popularity', to: 'admin#retrieve_popularity_metrics', as: :metrics_popularity
    post '/range_popularity', to: 'admin#retrieve_popularity_range', as: :metrics_popularity_range
  end

  scope '/admin' do
    post '/all-users', to: 'admin#retrieve_users', as: :admin_all_users
    post '/update-user', to: 'admin#update_user', as: :admin_update_user
    post '/new-user', to: 'admin#new_user', as: :admin_new_user
    post '/remove-user', to: 'admin#remove_user', as: :admin_remove_user

    post('/update-manager',
         to: 'admin#update_team_manager',
         as: :admin_update_team_manager)
    post '/add-player', to: 'admin#add_team_player', as: :admin_add_team_player
    post('/remove-player',
         to: 'admin#remove_team_player',
         as: :admin_remove_team_player)
  end

  resources :admin, only: :index do
    resources :teams, only: :index, module: 'admin'
    resources :teams, only: [] do
      post 'set-owner', to: 'admin/teams#set_owner'
      post 'add-member', to: 'admin/teams#add_member'
    end

    resources :user_teams, only: [] do
      post 'remove', to: 'admin/teams#remove_member'
      post 'update-roles', to: 'admin/teams#update_member_roles'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  post 'visitor-tracker', to: 'pages#visitors'
end
