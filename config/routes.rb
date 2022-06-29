Rails.application.routes.draw do
  resources :portofolios
  resources :freelancers, only: [:index, :new, :create, :show, :edit, :update]
  resources :clients, only: [:index, :new, :create, :show, :edit, :update]
  resources :users, only: [:show, :edit, :update, :destroy]
  match '/users' => "application#not_found", via: :get
  
  get '/' => "home#index", as: 'home'

  get '/register' => "users#new", as: 'register'
  post '/register'  => "users#create"

  get '/login'  => "auth#form_login", as: 'form_login'
  post '/login' => "auth#login"
  
  delete '/logout/:id' => "auth#logout", as: 'logout'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
