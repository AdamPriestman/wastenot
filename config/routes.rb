Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "search", to: "pages#search"
  resources :recipes, only: [:index, :show] do
    post 'filter', on: :collection
    post 'sort', on: :collection
    resources :bookmarks, only: [:create]
    resources :posts, only: [:new, :create]
  end
  resources :bookmarks, only: [:index, :new, :destroy]
  resources :posts, only: [:index, :edit, :update, :destroy]

end
