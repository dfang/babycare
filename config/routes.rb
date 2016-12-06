Rails.application.routes.draw do

  get 'wxpay/config'

  namespace :my do
    namespace :doctors do
      resources :transactions, only: [:index, :show, :create, :show]

      get 'wallet', to: 'wallets#index'
      get 'wallet/withdraw', to: 'wallets#withdraw'
    end
  end

  get 'wxjssdk/config'
  get 'payment/pay'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'wechat_authorize' => 'users/sessions#wechat_authorize', as: :wechat_authorize
    get 'profile' => 'users/registrations#show', as: :profile
  end

  resources :users do
    member do
      get :scan_qrcode
      get :qrcode
    end
  end

  get 'global/status'
  get 'global/denied'
  get 'global/switch'

  # get 'posts/index'
  # get 'posts/show'

  resources :posts, only: [:index, :show]

  namespace :wx do
     get '/' => 'service#verify'
     post '/' => 'service#create', :defaults => { :format => 'xml' }
     get '/wx_web_auth' => 'service#wx_web_auth'
  end

  namespace :my do

    namespace :doctors do
      resources :reservations do
        get 'claim', on: :member
        put 'claim', on: :member
        put 'complete_offline_consult', on: :member
        put 'complete_online_consult', on: :member
      end
      resources :patients do
        member do
          get 'profile'
          resources :medical_records, as: :patient_medical_records
          resources :reservations, as: :patient_reservations
        end
      end
      get 'status'
      get 'index'
      get 'profile'
      resources :medical_records
    end

    namespace :patients do
      resource :settings

      resources :reservations do
        get 'payment', on: :member
        put 'payment', on: :member
        get 'pay', on: :member
        get 'wxpay', on: :collection
        post 'payment_notify', on: :collection
      end
      get 'profile'
      get 'status'
      get 'index'
      resources :medical_records
    end
    get '/doctors', to: 'doctors#index', as: :doctor_root
    get '/patients', to: 'patients#index', as: :patient_root

  end

  resources :background_jobs, only: [] do
    post :call, on: :collection
    post :call_support, on: :collection
    post :cancel_reservation, on: :collection
  end

  resources :global_images, only: :create

  namespace :admin do
    resources :symptoms
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
    get 'status', on: :member
    get 'restricted', on: :collection
    get 'wxpay_test', on: :member
    resources :ratings
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
