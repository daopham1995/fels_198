Rails.application.routes.draw do
  root "static_pages#show", page: "home"
  get "/pages/:page" => "static_pages#show", as: :page
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users, except: :destroy
  resources :relationships, only: [:create, :destroy, :index]
  resources :lessons, except: [:index, :destroy]
  resources :words, only: :index

  namespace :admin do
    resources :users, only: [:index, :destroy, :show]
    resources :categories do
      resources :words, only: :new 
    end 
    resources :words
  end
end
