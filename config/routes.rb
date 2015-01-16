Rails.application.routes.draw do
  get 'pages_controller/index'


  root 'pages_controller#index'

  resources :topics, only: [:index, :new, :create, :show, :destroy]
end
