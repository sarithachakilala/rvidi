Rvidi::Application.routes.draw do
  resources :parameters

  resources :documentations, :path => 'documentation' do
    resources :apis do
      resources :resources do
        resources :parameters
      end
    end
  end

  get 'auth/:provider/callback', to: 'user/sessions#create'
  namespace(:user) {

    get "password_resets/new"
    delete 'sign_out', to: 'sessions#destroy', :as => :sign_out

    resources :password_resets
    resources :sessions
    get "sign_in" => "sessions#new", :as => "sign_in"
    get "sign_up" => "accounts#new", :as => "sign_up"

    resources :accounts do
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
  }

  match 'auth/failure', to: redirect('/')

  match "/hdfvr/avc_settings.php" => "home#avc_settings"
  match "/hdfvr/save_video_to_db.php" => "home#saved_video"
  match "/hdfvr/jpg_encoder_download.php" => "home#save_snapshoot"


  match 'file-render' => 'home#my_file', :as => :my_file
  
  namespace(:web) {
    
    match 'video-player' => 'cameos#video_player', :as => :video_player
    match 'validate-video' => 'cameos#validate_video', :as => :validate_video
    
    resources :comments do
      collection do
        get 'show_all'
      end
    end
    resources :videos
    resources :cameos do
      collection do
        post 'check_password'
        get 'cameo_clipping'
      end
    end
    resources :shows do
      member do
        get 'view_invitation'
        get 'play_cameo'
      end
      collection do
        # get 'invite_friend'
        # get 'friends_list'
        get 'invite_friend_toshow'
        post 'check_password'
        get 'status_update'
        get 'add_twitter_invities'
        get 'download_complete_show'
      end
    end
    resources :users do
      collection do
        get 'search'
        get 'invite_friend'
      end
    end
  }
  
  resources :home do
    collection do
      get 'terms_condition'
      # post 'friends_list'
    end
  end

  root :to => "home#index"

end
