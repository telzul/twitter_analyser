Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'


  get '/search', :to => 'pages#show'
  get '/status', :to => 'pages#status'
  get '/refresh', :to => 'pages#refresh'

  root 'pages#index'
end
