Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/search', :to => 'pages_controller/#search'

  root 'pages_controller#index'
end
