Rails.application.routes.draw do
  devise_for :users, :controllers =>
    {
      omniauth_callbacks: "users/omniauth_callbacks",
      registrations: "registrations"
    }

  root 'home#index'

  match '/users/:id/finish_signup' =>
    'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :favorites, only:
    [
      :index,
      :create,
      :destroy,
      :show
    ]

  resources :messages, only:
    [
      :show,
      :index,
      :new,
      :create,
      :destroy
    ]

  resources :users, only: [:show]

end
