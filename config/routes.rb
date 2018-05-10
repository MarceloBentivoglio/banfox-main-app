Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'pages#home'
  resources :client_steps
end
