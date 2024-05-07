Rails.application.routes.draw do
  resources :tokens
  resources :queue_users
  resources :customers
  resources :admins
  resources :admin_controller, only: [:new, :create, :destroy]


  #set route 
  # Token
  get "tokens", to: "tokens_#index"
  post "tokens", to: "tokens_#create"
  put "tokens/:id", to: "tokens_#update"
  delete "tokens/:id", to: "tokens_#destroy"
  # Admin
  get "admin", to: "admins_#index"
  post "admin/login", to: "admins_#check_login"
  post "/admins", to: "admin_controller#create"
  post "/admin/show", to: "admins_#show"

  resources :WebhooksController, only: [:receive]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end