Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'pages_controller/index'

  root 'pages_controller#index'

  resources :topics, only: [:index, :new, :create, :show, :destroy]
  resources :tweets, only: [:index, :show]
end
