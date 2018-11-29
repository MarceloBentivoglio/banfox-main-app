Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ForestLiana::Engine => '/forest'
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: 'pages#home'
  get "howitworks", to: "pages#howitworks"
  get "about_us", to: "pages#about_us"
  get "solution", to: "pages#solution"
  get "unfortune", to: "pages#unfortune"
  get "takeabreath", to: "pages#take_a_breath"
  get 'sellers/dashboard'
  get 'sellers/analysis'

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }
  resources :seller_steps
  resources :invoices, only: [:create, :destroy, :show]
  resources :installments, only: [:destroy] do
    collection do
      get :store
      get :opened
      get :history
    end
  end
  resources :operations, only: [:create, :update, :destroy] do
    collection do
      get :consent
      get :view_contract
    end
  end
  resources :documents, only: [:index, :new, :create, :destroy]

  match '/contacts', to: 'contacts#new', via: 'get'
  resources :contacts, only: [:new, :create]
end
