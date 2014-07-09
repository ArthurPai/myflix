Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/forgot_password', to: 'forgot_password#new'
  post '/forgot_password', to: 'forgot_password#create'
  get '/confirm_password_reset', to: 'forgot_password#confirm'
  get '/reset_password', to: 'reset_password#new'
  post '/reset_password', to: 'reset_password#create'
  get '/invalid_token', to: 'reset_password#invalid_token'

  get '/my_queue', to: 'queue_items#index'
  patch '/update_queue', to: 'queue_items#update'
  get '/people', to: 'fellowships#index'

  get '/invite', to: 'invitations#new'
  post '/invite', to: 'invitations#create'

  resources :users, only: [:create, :show]
  resources :videos, only: [:index, :show] do
    collection do
      get 'search'
    end

    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :fellowships, only: [:create, :destroy]
end
