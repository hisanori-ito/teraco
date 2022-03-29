Rails.application.routes.draw do
  # get 'ralationships/follows'
  # get 'ralationships/followers'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "/about"=>"homes#about"
  
  # ↓メール機能追加により、ルーティングの記述変更
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  
  # ↓ゲストログイン機能
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    resource :bookmarks, only: [:create, :destroy]
  end

  get 'search_tag' => 'posts#search_tag'
  get 'search' => 'posts#search'
  
  get 'sort_time' => 'posts#sort_time'
  get 'rank_favorite' => 'posts#rank_favorite'
  get 'rank_comment' => 'posts#rank_comment'
  get 'rank_bookmark' => 'posts#rank_bookmark'
  get 'rank_view' => 'posts#rank_view'

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follows', as: 'follows'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'bookmarks' => 'bookmarks#index', as: 'bookmarks'
    get 'favorites' => 'favorites#index', as: 'favorites'
  end

  resources :notifications, only: [:index]
end
