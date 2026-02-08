Rails.application.routes.draw do
  root "tasks#index"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "register", to: "registrations#new"
  post "register", to: "registrations#create"

  resources :tasks, only: [:index, :new, :create, :show, :destroy]
end
