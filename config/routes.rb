Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'pages#home'
  resources :seller_steps
  get "pages/howitworks", to: "pages#howitworks"
end
