# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :teams

  resources :teams do
    resources :user_teams
    resources :invites
    get 'published_invites', to: 'invites#published_invites', as: :published_invites
    resources :matches do
      post 'toggle_availability/:user_id', to: 'matches#toggle_availability', as: :toggle_availability
      resources :match_events, only: %i[create destroy]
      member do
        post :rate_players
        put :postpone
        put :resume
        post :submit_lineup
      end
    end
    get 'fixtures', to: 'matches#fixtures', as: :fixtures
    member do
      get 'player/:user_id', to: 'teams#player_stats', as: 'player_stats'
      get 'league'
      get :sync_fixtures
      post :sync_fixtures, action: :create_fixtures
    end
  end

  resources :user_teams do
    member do
      post 'accept'
      delete 'reject'
    end
  end

  resources :reports

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
    post '/update-visitor', to: 'metrics#update_visitor'

    post '/popularity', to: 'admin#retrieve_popularity_metrics', as: :metrics_popularity
    post '/range_popularity', to: 'admin#retrieve_popularity_range', as: :metrics_popularity_range
  end

  scope '/admin' do
    post('/update-manager',
         to: 'admin#update_team_manager',
         as: :admin_update_team_manager)
    post '/new-team', to: 'admin#new_team', as: :admin_new_team
    post '/add-player', to: 'admin#add_team_player', as: :admin_add_team_player
    post('/remove-player',
         to: 'admin#remove_team_player',
         as: :admin_remove_team_player)
    post '/unsolved-reports', to: 'admin#retrieve_unsolved_reports', as: :admin_unsolved_reports
    post '/solved-reports', to: 'admin#retrieve_solved_reports', as: :admin_solved_reports
    post '/set-report-to-solved', to: 'admin#set_report_to_solved', as: :admin_set_report_to_solved
  end

  # TODO: I don't think these admin routes really need the admin resource
  # E.g.:
  # scope '/admin', shallow_prefix: 'admin' do
  # namespace 'admin'
  #   resources :users, module: 'admin', shallow: true, only: :show do
  #     post 'new'
  #     post 'update'
  #     post 'remove'
  #   end
  # end

  resources :admin, only: :index do
    scope module: 'admin' do
      post 'users/new'
    end

    resources :users, module: 'admin', only: :show do
      post 'update'
      post 'wide_update'
      post 'remove'
      get 'destroy'
    end

    # resources :teams, only: :index, module: 'admin'
    resources :teams, module: 'admin', only: :show do
      post 'update'
      post 'small-update'
      post 'add-member'
      get 'destroy'
    end

    resources :user_teams, module: 'admin', only: [] do
      post 'remove', to: 'teams#remove_member'
      post 'update-roles', to: 'teams#update_member_roles'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#index'

  post 'visitor-tracker', to: 'pages#visitors'
end
