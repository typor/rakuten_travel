RakutenTravel::Application.routes.draw do
  resources :areas
  resources :hotels
  resources :charges

  namespace :admin do
    get "/" => "dashboard#index", as: :dashboard
    delete "logout" => "sessions#destroy", as: :logout
    get "login" => "sessions#new", as: :login
    resources :sessions, only: %w(create)
  end
end
