Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
  #get /users "users#index" user_path
  #get /users/:id "users#show" user_path(user)
  #get /users/:id/edit "users/edit" edit_user_path(user)
  #get /users/new "users#new" new_user_path
  #post /users "users#create" user_path
  #delete /users/:id "users#destroy" user_path(user)
  #patch "users/:id" "users#update" user_path(user)
end