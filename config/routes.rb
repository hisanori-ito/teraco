Rails.application.routes.draw do
  get 'ralationships/follows'
  get 'ralationships/followers'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "/about"=>"homes#about"

  devise_for :users

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    resource :bookmarks, only: [:create, :destroy]
  end
  
  get 'search_tag' => 'posts#search_tag'
  
  get 'search' => 'posts#search'
  
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follows', as: 'follows'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
end
