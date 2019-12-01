Rails.application.routes.draw do

  resources :feedbacks
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  require 'sidekiq/cron/web'
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
    namespace :ops_admin do
      resources :key_indicator_reports
      resources :key_indicator_report_requests
      resources :installments, only: [] do
        member do
          get 'approve'
          get 'reject'
          get 'deposit'
          get 'report_paid'
          get 'report_pdd'
        end
      end
      resources :sellers, only: [:index, :edit, :update] do
        member do
          get 'pre_approve'
          get 'reject'
          get 'approve'
          get 'forbid_to_operate'
          get 'never_ever_talk_about_this_link'
          get 'never_ever_talk_about_this_link_password'
        end
        resources :joint_debtors, only: [:index, :new, :create, :edit, :update, :destroy]
      end
      namespace :operations do
        get 'analyse'
        get 'deposit'
        get 'follow_up'
        get 'billing_rulers'
        post 'send_billing_mail'
      end
    end
  end

  get "howitworks", to: "pages#howitworks"
  get "about_us", to: "pages#about_us"
  get "solution", to: "pages#solution"
  get "unfortune", to: "pages#unfortune"
  get "takeabreath", to: "pages#take_a_breath"
  get "billing_ruler_not_found", to: "pages#billing_ruler_not_found"
  get "billing_ruler_paid", to: "pages#billing_ruler_paid"
  get "billing_ruler_pending", to: "pages#billing_ruler_pending"
  get 'sellers/dashboard'
  get 'sellers/analysis'
  get "signature/:signature_key", to: "signatures#joint_debtor"
  get "signature_d4sign/:signature_key", to: "signatures#joint_debtor_d4sign"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }

  devise_scope :user do
    post "create_signup", to: "signup#create"
    put  "update_signup", to: "signup#update"
  end

  get "how_digital_certificate_works", to: "digital_certificate_signup#how_digital_certificate_works"
  get "digital_certificate_upload", to: "digital_certificate_signup#file_upload"
  get "digital_certificate_finished", to: "digital_certificate_signup#finished"

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
      get :create_document_d4sign
      get :sign_document
      get :sign_document_d4sign
      put :cancel
    end
  end
  get "check_sign_document_status/:id", to: "operations#check_sign_document_status"

  resources :documents, only: [:index, :new, :create, :destroy]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "get_chat_room", to: "chat#get_chat_room"
      post "send_message", to: "chat#send_message"
      resources :pdf_parsed_invoices, only: [ :create ]
      resources :mobile_inputed_invoices, only: [ :create ]
      resources :billing_ruler_responses do
        member do
          get :paid
          get :pending
        end
      end
      namespace :contact_us do
        post "lp_contact"
      end
      namespace :operations do
        post "sign_document_status"
        post "webhook_response"
      end
      namespace :stone do
        match "welcome", to: "clients#welcome", via: :all
        match "update", to: "clients#update", via: :all
      end
    end
  end
  match '/contacts', to: 'contacts#new', via: 'get'
  resources :contacts, only: [:new, :create]
end
