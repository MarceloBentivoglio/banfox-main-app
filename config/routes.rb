Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ForestLiana::Engine => '/forest'
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
    namespace :ops_admin do
      resources :installments, only: [] do
        member do
          get 'approve'
          get 'reject'
          get 'deposit'
        end
      end
      namespace :operations do
        get 'analyse'
        get 'deposit'
      end
    end
  end

  root to: 'pages#home'
  get "howitworks", to: "pages#howitworks"
  get "about_us", to: "pages#about_us"
  get "solution", to: "pages#solution"
  get "unfortune", to: "pages#unfortune"
  get "takeabreath", to: "pages#take_a_breath"
  get 'sellers/dashboard'
  get 'sellers/analysis'
  get "signature/:signature_key", to: "signatures#joint_debtor"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }
  resources :seller_steps
  resources :invoices, only: [:destroy, :show]
  resources :invoices_documents_bundles, only: [:create] do
    collection do
      get :analysis
    end
  end
  resources :installments, only: [:destroy] do
    collection do
      get :store
      get :opened
      get :history
    end
  end
  resources :operations, only: [:create, :destroy] do
    collection do
      get :consent
      get :create_document
      get :sign_document
    end
  end
  resources :documents, only: [:index, :new, :create, :destroy]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :pdf_parsed_invoices, only: [ :create ]
      resources :mobile_inputed_invoices, only: [ :create ]
      namespace :operations do
        post "sign_document_status"
      end
    end
  end



  match '/contacts', to: 'contacts#new', via: 'get'
  resources :contacts, only: [:new, :create]
end
