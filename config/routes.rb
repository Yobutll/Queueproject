Rails.application.routes.draw do
  resources :tokens
  resources :queue_users
  resources :customers
  resources :admins
  resources :admin_controller, only: [:new, :create, :destroy]

  post "admin/login", to: "admins_#check_login"
  post "/admin", to: "admin_controller#create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
