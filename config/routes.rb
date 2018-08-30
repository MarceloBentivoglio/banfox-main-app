Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ForestLiana::Engine => '/forest'
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: 'pages#home'

  get 'sellers/show'
  get 'sellers/dashboard'
  get 'sellers/analysis'
  get 'sellers/unfortune'

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }
  resources :seller_steps
  resources :invoices, only: [:new, :create, :destroy, :show] do
    collection do
      get :store
      get :opened
      get :history
    end
  end
  resources :installments, only: [:destroy]
  resources :operations, only: [:destroy]
  resources :documents, only: [:index, :new, :create, :destroy]
end
