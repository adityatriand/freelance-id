Rails.application.routes.draw do

  post '/register'  => "users#create"

  post '/login' => "auth#login"

  delete '/logout/:id' => "auth#logout"

  resources :freelancers
  resources :clients
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
