# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  namespace :doctors do
    get 'reservation_examinations/new'
    get 'reservation_examinations/update'
    get 'reservation_examinations/create'
  end

  # get 'doctors/contract' => 'doctors#contract'
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

  get '/terms', to: 'page#terms'
  get '/support', to: 'page#support'
  get '/feedback', to: 'page#feedback'

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

    get 'wechat/authorize' => 'users/sessions#wechat_authorize'
    get 'wechat/scan' => 'users/sessions#wechat_scan'
    get 'wechat/auth_callback' => 'users/sessions#auth_callback'
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

    get '/payment' => 'wxpay#payment'
    post '/payment_notify' => 'wxpay#payment_notify'
  end

  namespace :doctors do
    resources :transactions, only: %i[index show create show]
    get 'wallet', to: 'wallets#index'
    get 'wallet/withdraw', to: 'wallets#withdraw'

    get 'contract'
    post 'contract'

    resources :reservations do
      # 扫码时无预约提示页面
      get 'not_found', on: :collection
      get 'status', on: :member
      # get 'detail', on: :member
      # get 'claim', on: :member
      # put 'claim', on: :member
      # put 'complete_offline_consult', on: :member
      # put 'complete_online_consult', on: :member
      get 'chief_complains', on: :collection
      get 'examinations_review', on: :collection
    end

    resources :ratings

    resources :examinations, only: %i[new edit update create destroy] do
      # 这里的路由没有按照restful来，一定要传reservtion_id
      # doctors/examinations/new?reservation_id
      # doctors/examinations/edit?reservation_id
      # doctors/examinations/update?reservation_id
      get 'edit', on: :collection
      put 'update', on: :collection
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
    resources :examinations
    resources :ratings

    resources :reservations do
      get 'pay', on: :collection

      get 'latest', on: :collection
      # get 'payment', on: :member
      # put 'payment', on: :member

      get 'wxpay', on: :collection
      post 'payment_notify', on: :collection
      delete 'cancel', on: :member
      get 'status', on: :member
      get 'examinations_uploader', on: :collection
      get 'chief_complains', on: :collection
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
      get 'sign'
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
    # resources :ratings
  end

  devise_for :admin_users, controllers: {
    sessions: 'admin/users/sessions'
  }

  mount ActionCable.server => '/cable'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, as: :graphiql, at: "/graphiql", graphql_path: "/graphql"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
