Rails.application.routes.draw do
  get 'clients/new'

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'pages#home'

  # resource :wizard do
  #   get :step1
  #   get :step2
  #   get :step3
  #   get :step4

  #   post :validate_step
  # end
end


# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
