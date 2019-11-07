Rails.application.routes.draw do
  root to: 'top_pages#home'
  post 'callback', to: 'line_bot#callback'
  delete 'line_logout', to: 'posts#line_logout'
  resources :posts
  resources :splints
end
