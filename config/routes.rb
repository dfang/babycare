# coding: utf-8
# frozen_string_literal: true

Rails.application.routes.draw do

  post 'simple_captcha/request_captcha'
  post 'simple_captcha/simple_captcha_valid'

  resources :products, only: %i[index show]

  get 'auth_token' => 'authentication#authenticate_token'

  root 'home#index'
  get 'home/index'
  get 'home/cities'
  get 'home/city'
  get 'home/hospitals'
  get 'home/doctors'
  get 'home/hospital'

  get 'payment/pay'
  get 'global/status'
  get 'global/denied'
  get 'global/switch'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'wechat_authorize' => 'users/sessions#wechat_authorize', as: :wechat_authorize
    get 'profile' => 'users/registrations#show', as: :profile

    get 'validate_phone' => 'users/registrations#validate_phone', as: :validate_phone
    get 'bind_phone_success' => 'users/registrations#bind_phone_success', as: :bind_phone_success
    get 'update_success' => 'users/registrations#update_success', as: :update_success
  end

  resources :users do
    member do
      get :scan_qrcode
      get :qrcode
    end
  end

  resources :posts, only: %i[index show]
  resources :global_images, only: :create

  namespace :wx do
    get '/' => 'service#verify'
    post '/' => 'service#create', :defaults => { format: 'xml' }
    get '/config_jssdk' => 'service#config_jssdk'
    post '/payment_notify' => 'wxpay#payment_notify'
  end

  namespace :doctors do
    resources :transactions, only: %i[index show create show]
    get 'wallet', to: 'wallets#index'
    get 'wallet/withdraw', to: 'wallets#withdraw'
    resources :reservations do
      get 'detail', on: :member
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
    resource :settings, only: :edit
    resources :family_members
    resources :reservations do
      get 'pay_deposit', on: :member
      get 'latest', on: :collection
      get 'payment', on: :member
      put 'payment', on: :member
      get 'pay', on: :member
      get 'wxpay', on: :collection
      post 'payment_notify', on: :collection
      delete 'cancel', on: :member
    end
    get 'profile'
    get 'status'
    get '/', action: :index
    get '/index', action: :index
    resources :medical_records
  end

  # 快捷方式
  namespace :my do
    get '/', to: 'home#index'
    get '/doctors', to: 'doctors#index', as: :doctor_root
    get '/patients', to: 'patients#index', as: :patient_root
  end

  resources :background_jobs, only: [] do
    post :call, on: :collection
    post :call_support, on: :collection
    post :cancel_reservation, on: :collection
  end

  resources :doctors do
    collection do
      get 'apply'
    end
    member do
      get 'reservations'
      get 'status'
    end
  end

  resources :reservations do
    get 'choose_type', on: :collection
    get 'public', on: :collection
    get 'status', on: :member
    get 'restricted', on: :collection
    get 'wxpay_test', on: :member
    resources :ratings
  end

  devise_for :admin_users, controllers: {
    sessions: 'admin/users/sessions'
  }

  namespace :admin do
    get 'images/create'

    resources :people do
      resources :medical_records
    end
    resources :medical_records
    resources :checkins
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
    resources :images, only: :create
    root 'dashboard#index'
    resources :users
    get 'dashboard' => 'dashboard#index'
    get 'customizer' => 'dashboard#customizer'
  end

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
