Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'sellers/show'
  mount ForestLiana::Engine => '/forest'
  root to: 'pages#home'
  get "pages/howitworks", to: "pages#howitworks"
  get "pages/newhome", to: "pages#newhome"
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
  resources :documents, only: [:index, :new, :create, :destroy]
end
