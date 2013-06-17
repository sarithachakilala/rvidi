Rvidi::Application.routes.draw do
  get "password_resets/new"

  resources :password_resets
  resources :comments do
    collection do
      get 'show_all'
    end
  end
  resources :videos
  resources :cameos do
    collection do 
      post 'check_password'
    end
  end
  resources :shows do
    member do
      get 'view_invitation'
      get 'play_cameo'
    end
    collection do
      get 'invite_friend'
      get 'friends_list'
      get 'invite_friend_toshow'
      post 'check_password'
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
      get 'dashboard', :path => "/home"
      get 'friends'
      get 'friend_profile'
      get 'notification'
    end
    collection do
      get 'friends_list'
      get 'send_friend_request'
      get 'accept_friend_request'
      get 'ignore_friend_request'
      get 'invite_friend_via_email'
      get 'add_twitter_friends'
      post 'add_facebook_friends'
    end
  end
  resources :home do
    collection do
      get 'terms_condition' 
      # post 'friends_list' 
    end
  end

  root :to => "home#index"
  
end
