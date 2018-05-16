Rails.application.routes.draw do

  root to: 'pages#home'
  get "pages/howitworks", to: "pages#howitworks"
  devise_for :users, controllers: { registrations: "registrations" }
  resources :seller_steps
end
