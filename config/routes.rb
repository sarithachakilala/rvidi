Rvidi::Application.routes.draw do

  resources :cameos
  resources :shows do
    member do
      get 'view_invitation'
    end
  end
  resources :sessions

  match "/auth/twitter/callback" => "sessions#create"
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out'

  get "home/index"
  get "sessions/new"

  get "sign_in" => "sessions#new", :as => "sign_in"
  get "sign_up" => "users#new", :as => "sign_up"
  
  resources :users do
    member do
      get 'oauth_failure'    
      get 'profile'
      get 'getting_started'
      get 'dashboard'
      get 'friends'
      get 'friend_profile'
    end
  end

  root :to => "home#index"
  
end
