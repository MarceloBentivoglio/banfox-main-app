Rails.application.routes.draw do

  get 'invoices/index'
  get 'invoices/new'
  root to: 'pages#home'
  get "pages/howitworks", to: "pages#howitworks"
  devise_for :users, controllers: { registrations: "registrations" }
  resources :seller_steps
  resources :invoices, only: [:index, :new, :create, :destroy]
end
