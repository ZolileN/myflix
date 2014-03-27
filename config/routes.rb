Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'relationships#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :videos, except: [:destroy] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :categories, except: [:destroy]
  resources :users, only: [:create, :show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy, :create]
  resources :sessions, only: [:create]
  
end 
