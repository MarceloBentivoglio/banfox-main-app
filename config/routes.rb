Rails.application.routes.draw do
  get 'clients/new'

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'pages#home'

  resources :clients, only: [:new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
