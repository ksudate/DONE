Rails.application.routes.draw do
  resources :posts
  get 'top_pages', to: 'top_pages#home'
  get 'callback', to: 'linebot#callback'
  post 'callback', to: 'linebot#webhook'
end
