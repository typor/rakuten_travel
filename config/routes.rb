require 'sidekiq/web'
require 'rakuten_travel/admin_constraint'
RakutenTravel::Application.routes.draw do
  namespace :front, path: '/' do
    resources :hotels, only: %w(index show)
  end

  namespace :admin do
    get "/" => "dashboard#index", as: :dashboard
    delete "logout" => "sessions#destroy", as: :logout
    get "login" => "sessions#new", as: :login
    get 'welcome' => 'welcome#new', as: :welcome
    post 'welcome' => 'welcome#create'
    resources :sessions, only: %w(create)
    resources :areas, except: %w(show) do
      get 'import', on: :collection
      get 'import_hotels', on: :member
      get 'toggle', on: :member
    end
    resources :hotels do
      get 'toggle', on: :member
    end
    resources :charges, only: %w(index show)
    resources :plans
    resources :rooms
    resources :accounts, except: %w(show)
    mount Sidekiq::Web => '/sidekiq', constraints: ::RakutenTravel::AdminConstraint.new
  end
end
