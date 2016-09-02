Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'wechat_authorize' => 'users/sessions#wechat_authorize', as: :wechat_authorize
    get 'profile' => 'users/registrations#show', as: :profile
  end


  get 'global/status'
  get 'global/denied'

  get 'posts/index'
  get 'posts/show'

  namespace :wx do
     get '/' => 'service#verify'
     post '/' => 'service#create', :defaults => { :format => 'xml' }
     get '/wx_web_auth' => 'service#wx_web_auth'
  end

  namespace :my do
    namespace :doctors do
      resources :reservations
      get 'status'
      get 'index'
    end

    namespace :patients do
      resources :reservations do
        get 'payment_te', on: :collection
        post 'payment_notify', on: :collection
      end
      get 'status'
      get 'index'
    end

    get '/doctors', to: 'doctors#index', as: :doctor_root
    get '/patients', to: 'patients#index', as: :patient_root

  end

  resources :background_jobs, only: [] do
    post :call, on: :collection
    post :call_support, on: :collection
  end

  resources :global_images, only: :create

  namespace :admin do
    resources :wx_menus do
      collection do
        get 'sync'
        get 'load_remote'
      end
    end

    resources :doctors do
      put :confirm, on: :member
    end

    resources :posts do
      put :publish, on: :member
    end
  end

  resources :doctors do
    collection do
      get 'apply'
    end
    member do
      get 'reservations'
      get 'status'
      put 'online'
      put 'offline'
    end
  end


  

  

  resources :reservations do
    get 'public', on: :collection
    get 'claim', on: :member
    put 'claim', on: :member
    get 'status', on: :member
    get 'wxpay_test', on: :member
  end

  namespace :admin do
    get 'images/create'

    resources :people do
      resources :medical_records
    end
    resources :medical_records
  end

  resources :people
  namespace :admin do
    resources :checkins
  end

  resources :checkins
  resources :books

  devise_for :admin_users, controllers: {
    sessions: 'admin/users/sessions'
  }

  namespace :admin do
    resources :images, only: :create
    root 'dashboard#index'
    resources :users
    get 'dashboard' => 'dashboard#index'
    get 'customizer' => 'dashboard#customizer'
  end

end
