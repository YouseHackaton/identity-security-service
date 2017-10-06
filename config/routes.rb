Rails.application.routes.draw do
  root 'users#edit'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resource :users, only: [:edit, :update]
end
