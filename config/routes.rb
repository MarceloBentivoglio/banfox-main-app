Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  root to: 'pages#home'
  get "pages/howitworks", to: "pages#howitworks"
  devise_for :users, controllers: { registrations: "registrations" }
  resources :seller_steps
  resources :invoices, only: [:index, :new, :create, :destroy]
  resources :documents, only: [:index, :new, :create, :destroy]
end
