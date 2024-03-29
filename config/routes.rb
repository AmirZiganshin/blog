Rails.application.routes.draw do
  devise_for :controllers
  devise_for :model1, controllers: { sessions: 'model1s/sessions' }
defaults format: :json do
  resource :bot, only: %i[create]
end
root 'posts#index', as: 'home'
get 'about' => 'pages#about', as: 'about'
get 'new' => 'posts#new', as: 'new'
get 'moderate' => 'moderation#moderate', as: 'moderate'
patch 'confirm' => 'moderation#confirm', as: 'confirm'
delete 'destroy' => 'moderation#destroy', as: 'destroy'
get 'laba1' => 'posts#laba1', as: 'laba1'
get 'category' => 'categories#index', as: 'cat'
get 'newcategory' => 'categories#new', as: 'newcat'
get 'postss' => 'posts#postss', as: 'postss'
get '/posts/search' => 'posts#search', as: 'search_posts'
get '/users/search' => 'users#search', as: 'search_users'
get 'user_posts/:model1_id' => 'posts#user', as: :user_posts
get 'allusers' => 'users#allusers', as: 'allusers'
get 'sendmassage' => 'bots#clientadmin', as: 'sendmassage'
get 'sendmassageadmin' => 'bots#clientuser', as: 'sendmassageadmin'
get 'comments' => 'bots#comments', as: 'comments'
get 'destroyy' => 'bots#destroy', as: 'destroyy'
patch 'resetchaid' => 'bots#resetchatid', as: 'resetchatid'
resources :moderation
resources :categories
resources :users
resources :posts do
    resources :comments
end
end
