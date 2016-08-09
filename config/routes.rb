Rails.application.routes.draw do

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
        get 'prepay', on: :member
      end
      get 'status'
      get 'index'
    end

    get '/doctors', to: 'doctors#index', as: :doctor_root
    get '/patients', to: 'patients#index', as: :patient_root

  end


  resources :background_jobs, only: [] do
    post :call, on: :collection
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

    resources :posts
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


  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'wechat_authorize' => 'users/sessions#wechat_authorize', as: :wechat_authorize
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
