# frozen_string_literal: true

Rails.application.routes.draw do

  root to: 'dashboards#show'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  # Submissions routes
  get 'submissions/new/:workout_post_id', to: 'submissions#new', as: 'new_submission'
  get 'submissions/edit/:workout_post_id', to: 'submissions#edit', as: 'edit_submission'
  post 'submissions/create', to: 'submissions#create'
  post 'submissions/update', to: 'submissions#update'

  get 'submissions/history/:workout_post_id', to: 'submissions#history', as: 'submissions_history'

  # Posts routes
  get 'posts/new/', to: 'posts#new', as: 'posts_new'
  post 'posts/create/', to: 'posts#create'

  # Permissions routes
  get 'permissions/', to: 'permissions#index', as: 'permissions'
  post 'permissions/', to: 'permissions#complete'

  # Profiles routes
  get 'profiles/:id/', to: 'profiles#show', as: 'profiles'
  get 'profiles/:id/edit/', to: 'profiles#edit', as: 'edit_profile'
  post 'profiles/:id/', to: 'profiles#update'

  get 'members/', to: 'members#index', as: 'members'

  # Admin-only routes for setting WOD dates
  get '/wod/set', to: 'wod#admin_view', as: 'set_wod'
  post '/wod/set', to: 'wod#update_wod'

  # User route for viewing the current and past WODs
  get '/wod', to: 'wod#user_view', as: 'user_wod'

  # Leaderboard and Fistbump routes
  get 'leaderboard', to: 'dashboards#leaderboard'
  post 'leaderboard/like/:exercise_submission_id', to: 'dashboards#like', as: 'leaderboard_like'
  post 'leaderboard/unlike/:exercise_submission_id', to: 'dashboards#unlike', as: 'leaderboard_unlike'

  get 'documentation', to: 'documentation#index'

  resources :exercises
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
