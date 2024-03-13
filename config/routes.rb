# frozen_string_literal: true

Rails.application.routes.draw do
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

  devise_for :users

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

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'
end
