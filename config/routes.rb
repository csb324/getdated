Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks"}

  root 'home#index'

  resources :members, :controller => 'users'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :favorites, only: [:index, :create, :destroy]

  resources :messages, only: [:show, :index,:new, :create, :destroy]

  resources :users, only: [:show]

end
