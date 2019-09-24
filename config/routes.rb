Rails.application.routes.draw do
  resources :posts
  get 'top_pages', to: 'top_pages#home'
  post 'callback', to: 'linebot#callback'
end
