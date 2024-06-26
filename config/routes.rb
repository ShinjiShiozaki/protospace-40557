Rails.application.routes.draw do
  devise_for :users
  root 'prototypes#index'
  #resources :prototypes
  #resources :prototypes, only: [:index, :new, :create, :show]
  resources :prototypes, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: :create 
  end
  resources :users, only: :show
end
