Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'


  get '/search', :to => 'pages#show'
  get '/status', :to => 'pages#status'

  root 'pages#index'
end
