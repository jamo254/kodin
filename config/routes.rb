Rails.application.routes.draw do
  get "profiles/new"
  get "profiles/show"
  get "profiles/edit"
 
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "posts#index"
  
  # Posts routes
  resources :posts
  get 'tags/:tag', to: 'posts#tag', as: :tag
  get ':username', to: 'profiles#show', as: :profile
  get 'settings/profile', to: 'profiles#edit', as: :edit_profile
  patch 'settings/profile', to: 'profiles#update', as: :update_profile
end
