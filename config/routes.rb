Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'videos#index'
  get '/home', to: 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search'
    end
  end
  resources :categories, only: [:show]
end
