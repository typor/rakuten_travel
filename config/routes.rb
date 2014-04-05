RakutenTravel::Application.routes.draw do

  namespace :admin do
    get "/" => "dashboard#index", as: :dashboard
    delete "logout" => "sessions#destroy", as: :logout
    get "login" => "sessions#new", as: :login
    get 'welcome' => 'welcome#new', as: :welcome
    post 'welcome' => 'welcome#create'
    resources :sessions, only: %w(create)
    resources :areas, except: %w(show)
    resources :hotels
    resources :charges
  end
end
