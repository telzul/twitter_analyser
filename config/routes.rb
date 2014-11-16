Rails.application.routes.draw do
  get 'pages_controller/index'


  root 'pages_controller#index'
end
