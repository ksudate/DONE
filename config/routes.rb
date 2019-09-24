Rails.application.routes.draw do
  post 'callback', to: 'linebot#callback'
  resources :posts
  get '/', to: 'top_pages#home'
end
