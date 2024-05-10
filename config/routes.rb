Rails.application.routes.draw do
  resources :tokens
  resources :queue_users
  resources :customers
  resources :admins
  resources :admin_controller, only: [:new, :create, :destroy]
  
  match "admins_controller/new", to: "admins#new", via: [:get, :post]
  match "admins_controller/create", to: "admins#create", via: [:get, :post]
  match "admins_controller/index", to: "admins#index", via: [:get, :post]
  match "admins_controller/show", to: "admins#show", via: [:get, :post]
  # Auth
  match "auth/login", to: "authentication#login", via: [:get, :post]
  match "auth/req", to: "application#authenticate_request", via: [:get, :post]
  # Token
  match "tokens", to: "tokens#index", via: [:get, :post]
  match "tokens/Admin/tokens", to: "tokens#Admin_session", via: [:get, :post]
  match "tokens/delete", to: "tokens#destroy", via: [:get, :post]
  match "tokens/show", to: "tokens#show", via: [:get, :post]
  # Customer
  match "customers", to: "customers#index", via: [:get, :post]
  match "customers/create", to: "customers#create", via: [:get, :post]

  # Queue
  match "queue_users", to: "queue_users#index", via: [:get, :post]
  match "queue_users/create", to: "queue_users#create", via: [:get, :post]
  match "queue_users", to: "queue_users#show", via: [:update]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end