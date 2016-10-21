Rails.application.routes.draw do
  root "static_pages#show", page: "home"
  get "/pages/:page" => "static_pages#show"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users, except: [:index, :destroy]
  resources :relationships, only: [:create, :destroy, :index]
  resources :lessons, only: [:show]

  namespace :admin do
    resources :users, only: [:index, :destroy, :show]
    resources :categories, except: [:update, :edit]
  end
end
