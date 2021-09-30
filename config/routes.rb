Rails.application.routes.draw do
  # resources :books
  # resources :ocrtrackers
  root to: 'dashboards#show'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  resources :exercises, :workout_posts, :exercise_posts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end