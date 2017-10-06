Rails.application.routes.draw do
  root 'users#edit'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resource :users, only: [:edit, :update]
  resource :documents, only: [:edit, :update] do
    get :document_number
    put :document_number, to: 'documents#update_document_number'
  end
  resources :results, only: [:index]

  post '/users/auth/linkedin', to: 'users/omniauth_callbacks#passthru', as: 'user_linkedin_omniauth_authorize'
  get '/socials/linkedin', to: 'socials#linkedin', as: 'socials_linkedin'
  get 'linked_in', to: 'linked_in#index'
end
